import {CustomError} from '../custom_error';

export default class AlreadyReportedError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Already Reported User');
    Object.setPrototypeOf(this, AlreadyReportedError.prototype);
  }
}
