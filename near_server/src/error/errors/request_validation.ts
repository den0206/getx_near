import {ZodIssue} from 'zod';
import {CustomError} from '../custom_error';

export default class RequestValidationError extends CustomError {
  statusCode = 400;

  constructor(public issues: ZodIssue[]) {
    const message: string = issues
      .map((issue) => {
        return issue.message;
      })
      .join(', ');

    super(message);

    // this.paths = issues.map((issue) => {
    //   return issue.path[issue.path.length - 1];
    // });

    Object.setPrototypeOf(this, RequestValidationError.prototype);
  }
}
