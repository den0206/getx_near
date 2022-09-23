import {CustomError} from '../custom_error';

export default class TokenExpireError extends CustomError {
  statusCode = 401;

  constructor() {
    super('Token Expire');
    Object.setPrototypeOf(this, TokenExpireError.prototype);
  }
}
