import {CustomError} from '../custom_error';

export default class FailSendNotificationError extends CustomError {
  statusCode = 415;

  constructor() {
    super('Fail Send Notification');
    Object.setPrototypeOf(this, FailSendNotificationError.prototype);
  }
}
