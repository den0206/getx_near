import {Response} from 'express';
import ResponseAPI from '../utils/interface/response.api';

export abstract class CustomError extends Error {
  abstract statusCode: number;

  constructor(message: string) {
    super(message);
    Object.setPrototypeOf(this, CustomError.prototype);
  }
}

// 共通のエラーハンドリングを行う

export function commonErrorHandler(res: Response, e: any) {
  if (e instanceof CustomError)
    return new ResponseAPI(res, {error: e}).excute(e.statusCode);

  return new ResponseAPI(res, {error: e}).excute(500);
}
