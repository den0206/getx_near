import {NextFunction, Request, Response} from 'express';
import jwt from 'jsonwebtoken';
import TokenExpireError from '../error/errors/token_expire';
import TokenNotFoundError from '../error/errors/token_not_found';
import ResponseAPI from '../utils/interface/response.api';

export default function checkAuth(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const bearerHeader = req.headers.authorization;
  if (bearerHeader) {
    try {
      const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
      const token = bearerHeader.split(' ')[1];
      const decorded = jwt.verify(token, secret);

      res.locals.user = decorded;

      next();
    } catch (e) {
      const expire = new TokenExpireError();
      return new ResponseAPI(res, {error: expire}).excute(expire.statusCode);
    }
  } else {
    const notFound = new TokenNotFoundError();
    return new ResponseAPI(res, {error: notFound}).excute(notFound.statusCode);
  }
}
