import {CustomError} from '../custom_error';

export default class NotFoundRecentError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Not found Recent');
    Object.setPrototypeOf(this, NotFoundRecentError.prototype);
  }
}
