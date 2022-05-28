import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import {SignUpBody} from './user.validation';
import ResponseAPI from '../../utils/interface/response.api';
import {UserModel} from '../../utils/database/models';
import AWSClient from '../../utils/aws/aws_client';

async function signUp(req: Request<{}, {}, SignUpBody>, res: Response) {
  const {name, email, password} = req.body;
  const file = req.file;
  const isFind = await UserModel.findOne({email});

  if (isFind)
    return new ResponseAPI(res, {message: 'Email Alreadty Exist'}).excute(400);

  try {
    let user = new UserModel({name, email, password});

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
  } catch (e: any) {
    return new ResponseAPI(res, {message: e.message}).excute(500);
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
    if (!isFind)
      return new ResponseAPI(res, {message: 'No Exist Email'}).excute(400);

    const isVerify = await isFind.comparePasswrd(password);
    if (!isVerify)
      return new ResponseAPI(res, {message: 'Password not match'}).excute(400);

    const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
    const expiresIn = process.env.JWT_EXPIRES_IN;

    const payload = {userId: isFind.id, email: isFind.email};
    const token = jwt.sign(payload, secret, {expiresIn: expiresIn});

    const data = {user: isFind, token};

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateLocation(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {lng, lat} = req.body;

  try {
    const findUser = await UserModel.findById(userId);
    if (!findUser)
      return new ResponseAPI(res, {message: 'Can not fint The User'}).excute(
        404
      );

    const location = {type: 'Point', coordinates: [lng, lat]};

    const newUser = await findUser.updateOne({location: location}, {new: true});
    new ResponseAPI(res, {data: newUser}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}
export default {
  signUp,
  login,
  updateLocation,
};
