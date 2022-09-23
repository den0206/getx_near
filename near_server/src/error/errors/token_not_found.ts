import {CustomError} from '../custom_error';

export default class TokenNotFoundError extends CustomError {
  statusCode = 403;

  constructor() {
    super('Token Not Found');
    Object.setPrototypeOf(this, TokenNotFoundError.prototype);
  }
}
