import {Request, Response} from 'express';
import {commonErrorHandler} from '../../error/custom_error';
import AlreadyUseEmailError from '../../error/errors/already_email';
import ExpireResetTokenError from '../../error/errors/expire_reset_token';
import NotFoundEmailError from '../../error/errors/not_find_email';
import NotFoundUserError from '../../error/errors/not_find_user';
import {TempTokenModel, UserModel} from '../../utils/database/models';
import sendEmail from '../../utils/email/send_email';
import ResponseAPI from '../../utils/interface/response.api';
import {hashdPassword} from '../users/user.model';

// Email
async function requestNewEmail(req: Request, res: Response) {
  const {email} = req.body;

  try {
    const isFind = await UserModel.findOne({email});
    if (isFind) throw new AlreadyUseEmailError();

    const genetateNumber = await generateNumberAndToken(email);
    const payload = {id: email, otp: genetateNumber};

    await sendEmail({
      email: email,
      subject: 'Password Reset Request',
      payload: payload,
      template: '../email/template/sendOTP.handlebars',
    });
    new ResponseAPI(res, {data: 'Send Change Email'}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function verifyEmail(req: Request, res: Response) {
  const {email, verify} = req.body;
  try {
    const newEmailToken = await checkValid(email, verify);
    await sendEmail({
      email: email,
      subject: 'Confirm Email Successfully',
      payload: {email},
      template: '../email/template/verifyEmail.handlebars',
    });

    await newEmailToken.deleteOne();
    new ResponseAPI(res, {data: 'Success Valid Email'}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

// password

async function requestPassword(req: Request, res: Response) {
  const {email} = req.body;

  try {
    const isFind = await UserModel.findOne({email});
    if (!isFind) throw new NotFoundEmailError();

    const genetateNumber = await generateNumberAndToken(isFind._id);
    const payload = {id: isFind.name, otp: genetateNumber};
    await sendEmail({
      email: email,
      subject: 'Password Reset Request',
      payload: payload,
      template: '../email/template/sendOTP.handlebars',
    });
    new ResponseAPI(res, {data: isFind._id}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function verifyPassword(req: Request, res: Response) {
  const {userId, password, verify} = req.body;

  try {
    const passwordResetToken = await checkValid(userId, verify);
    const hash = await hashdPassword(password);
    const newUser = await UserModel.findByIdAndUpdate(
      userId,
      {password: hash},
      {new: true, useFindAndModify: true}
    );
    if (!newUser) throw new NotFoundUserError();

    await sendEmail({
      email: newUser.email,
      subject: 'Password Reset Successfully',
      payload: {name: newUser.name},
      template: '../email/template/verifyPassword.handlebars',
    });
    await passwordResetToken.delete();
    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

// private functions
async function generateNumberAndToken(tempId: string) {
  const token = await TempTokenModel.findOne({tempId});
  if (token) await token.deleteOne();
  const generateNumber = Math.floor(100000 + Math.random() * 900000);

  const newToken = new TempTokenModel({tempId, token: generateNumber});
  await newToken.save();
  return generateNumber;
}

async function checkValid(tempId: string, verify: string) {
  const currentToken = await TempTokenModel.findOne({tempId});
  if (!currentToken) throw new ExpireResetTokenError();
  const isValid = await currentToken.compareToken(verify);
  if (!isValid) throw new ExpireResetTokenError();
  return currentToken;
}

export default {
  requestNewEmail,
  verifyEmail,
  requestPassword,
  verifyPassword,
};
