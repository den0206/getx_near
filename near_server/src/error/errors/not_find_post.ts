import {CustomError} from '../custom_error';

export default class NotFoundPostError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Not found Post');
    Object.setPrototypeOf(this, NotFoundPostError.prototype);
  }
}
