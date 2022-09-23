import {CustomError} from '../custom_error';

export default class InvalidMongoIDError extends CustomError {
  statusCode = 400;

  constructor() {
    super('invalid ID');
    Object.setPrototypeOf(this, InvalidMongoIDError.prototype);
  }
}
