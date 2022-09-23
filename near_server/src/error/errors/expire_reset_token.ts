import {CustomError} from '../custom_error';

export default class ExpireResetTokenError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Invalid or expired password reset token');
    Object.setPrototypeOf(this, ExpireResetTokenError.prototype);
  }
}
