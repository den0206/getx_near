import {Request, Response} from 'express';
import {TempTokenModel, UserModel} from '../../utils/database/models';
import sendEmail from '../../utils/email/send_email';
import ResponseAPI from '../../utils/interface/response.api';
import {hashdPassword} from '../users/user.model';

// Email
async function requestNewEmail(req: Request, res: Response) {
  const {email} = req.body;

  try {
    const isFind = await UserModel.findOne({email});
    if (!isFind)
      return new ResponseAPI(res, {message: 'Already Use Thie Email'}).excute(
        400
      );

    const genetateNumber = await generateNumberAndToken(email);
    const payload = {id: email, otp: genetateNumber};

    await sendEmail({
      email: email,
      subject: 'Password Reset Request',
      payload: payload,
      template: '../email/template/sendOTP.handlebars',
    });
    new ResponseAPI(res, {data: isFind._id}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

// password

async function requestPassword(req: Request, res: Response) {
  const {email} = req.body;

  try {
    const isFind = await UserModel.findOne({email});
    if (!isFind)
      return new ResponseAPI(res, {message: 'Not find this Email'}).excute(400);

    const genetateNumber = await generateNumberAndToken(isFind._id);
    const payload = {id: isFind.name, otp: genetateNumber};
    await sendEmail({
      email: email,
      subject: 'Password Reset Request',
      payload: payload,
      template: '../email/template/sendOTP.handlebars',
    });
    new ResponseAPI(res, {data: isFind._id}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
    if (!newUser)
      return new ResponseAPI(res, {message: 'Not find the User'}).excute(400);

    await sendEmail({
      email: newUser.email,
      subject: 'Password Reset Successfully',
      payload: {name: newUser.name},
      template: '../email/template/verifyPassword.handlebars',
    });
    await passwordResetToken.delete();
    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
  try {
    const currentToken = await TempTokenModel.findOne({tempId});
    if (!currentToken)
      throw new Error('Invalid or expired password reset token');
    const isValid = await currentToken.compareToken(verify);
    if (!isValid) throw new Error('Invalid or expired password reset token');
    return currentToken;
  } catch (e: any) {
    throw e;
  }
}

export default {
  requestNewEmail,
  verifyEmail,
  requestPassword,
  verifyPassword,
};
