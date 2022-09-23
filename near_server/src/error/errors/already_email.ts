import {CustomError} from '../custom_error';

export default class AlreadyUseEmailError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Already use this email');
    Object.setPrototypeOf(this, AlreadyUseEmailError.prototype);
  }
}
