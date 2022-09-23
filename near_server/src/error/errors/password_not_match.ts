import {CustomError} from '../custom_error';

export default class PasswordNotMatchError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Password Not Match');
    Object.setPrototypeOf(this, PasswordNotMatchError.prototype);
  }
}
