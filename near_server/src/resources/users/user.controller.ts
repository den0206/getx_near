import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import {commonErrorHandler} from '../../error/custom_error';
import AlreadyUseEmailError from '../../error/errors/already_email';
import NotFoundEmailError from '../../error/errors/not_find_email';
import NotFoundUserError from '../../error/errors/not_find_user';
import PasswordNotMatchError from '../../error/errors/password_not_match';
import AWSClient from '../../utils/aws/aws_client';
import {UserModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import {SignUpBody} from './user.validation';

async function signUp(req: Request<{}, {}, SignUpBody>, res: Response) {
  const {name, email, sex, password, createdAt} = req.body;
  const file = req.file;
  const isFind = await UserModel.findOne({email});

  if (isFind) throw new AlreadyUseEmailError();

  try {
    const user = new UserModel({name, email, sex, password, createdAt});

    if (file) {
      const awsClient = new AWSClient();
      const extention = file.originalname.split('.').pop();
      const fileName = `${user._id}/avatar/avatar.${extention}`;
      const imagePath = await awsClient.uploadImage(file, fileName);
      if (!imagePath) throw Error('画像が保存できません');
      user.avatarUrl = imagePath;
      console.log(imagePath);
    }
    await user.save();
    new ResponseAPI(res, {data: user}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function login(req: Request, res: Response) {
  const {email, password, fcmToken} = req.body;

  try {
    const isFind = await UserModel.findOneAndUpdate(
      {email},
      {fcmToken},
      {new: true}
    );
    // const isFind = await UserModel.findOne({email});
    if (!isFind) throw new NotFoundEmailError();
    const isVerify = await isFind.comparePasswrd(password);

    if (!isVerify) throw new PasswordNotMatchError();

    const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
    const expiresIn = process.env.JWT_EXPIRES_IN;

    const payload = {userId: isFind.id, email: isFind.email};
    const token = jwt.sign(payload, secret, {expiresIn: expiresIn});

    const data = {user: isFind, token};

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function updateUser(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {name, email, avatarUrl} = req.body;
  const file = req.file;

  try {
    let imagePath = avatarUrl;
    if (file) {
      const awsClient = new AWSClient();
      const extention = file.originalname.split('.').pop();
      const fileName = `${userId}/avatar/avatar.${extention}`;
      imagePath = await awsClient.uploadImage(file, fileName);
      if (!imagePath) throw Error('画像が保存できません');
      console.log(imagePath);
    }

    const value = {name, email, avatarUrl: imagePath};
    const newUser = await UserModel.findByIdAndUpdate(userId, value, {
      new: true,
    });
    if (!newUser) throw new NotFoundUserError();

    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function updateLocation(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {lng, lat} = req.body;

  try {
    const findUser = await UserModel.findById(userId);
    if (!findUser) throw new NotFoundUserError();
    const location = {type: 'Point', coordinates: [lng, lat]};

    const newUser = await findUser.updateOne({location: location}, {new: true});
    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

// MARK Block User

async function blockUsers(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  try {
    const isFind = await UserModel.findById(userId)
      .select('blocked')
      .populate('blocked', '-password');

    if (!isFind) throw new NotFoundUserError();
    new ResponseAPI(res, {data: isFind.blocked}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}
async function updateBlock(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {blocked} = req.body;

  try {
    const value = {
      blocked,
    };

    const newUser = await UserModel.findByIdAndUpdate(userId, value, {
      new: true,
    });
    if (!newUser) throw new NotFoundUserError();

    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function deleteUser(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  try {
    const isFind = await UserModel.findById(userId);
    if (!isFind) throw new NotFoundUserError();

    await isFind.deleteOne();
    console.log('=== Complete DELETE');

    new ResponseAPI(res, {data: isFind}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}
export default {
  signUp,
  login,
  updateUser,
  updateLocation,
  updateBlock,
  blockUsers,
  deleteUser,
};
