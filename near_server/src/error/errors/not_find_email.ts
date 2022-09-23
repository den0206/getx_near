import {CustomError} from '../custom_error';

export default class NotFoundEmailError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Not found this Email');
    Object.setPrototypeOf(this, NotFoundEmailError.prototype);
  }
}
