import {Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import {SignUpBody} from './user.validation';
import ResponseAPI from '../../utils/interface/response.api';
import {UserModel} from '../../utils/database/models';

async function signUp(req: Request<{}, {}, SignUpBody>, res: Response) {
  const {name, email, password} = req.body;
  const isFind = await UserModel.findOne({email});

  if (isFind)
    return new ResponseAPI(res, {message: 'Email Alreadty Exist'}).excute(400);

  try {
    const user = new UserModel({name, email, password});

    await user.save();
    new ResponseAPI(res, {data: user}).excute(200);
  } catch (e: any) {
    return new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function login(req: Request, res: Response) {
  const {email, password} = req.body;
  try {
    const isFind = await UserModel.findOne({email});
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

export default {
  signUp,
  login,
};
