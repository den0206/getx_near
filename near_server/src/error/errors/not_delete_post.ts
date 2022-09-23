import {CustomError} from '../custom_error';

export default class NotDeletePostError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Not delete Post');
    Object.setPrototypeOf(this, NotDeletePostError.prototype);
  }
}
