import {CustomError} from '../custom_error';

export default class NotFoundUserError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Not foud The User');
    Object.setPrototypeOf(this, NotFoundUserError.prototype);
  }
}
