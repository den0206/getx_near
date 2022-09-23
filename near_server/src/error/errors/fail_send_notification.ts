import {CustomError} from '../custom_error';

export default class FailSendNotificationError extends CustomError {
  statusCode = 400;

  constructor() {
    super('Fail Send Notification');
    Object.setPrototypeOf(this, FailSendNotificationError.prototype);
  }
}
