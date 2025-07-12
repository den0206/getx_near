import {NextFunction, Request, Response} from 'express';
import {ZodError, ZodObject} from 'zod';
import RequestValidationError from '../error/errors/request_validation';
import ResponseAPI from '../utils/interface/response.api';

function zodValidate(schema: ZodObject<any>) {
  return async (
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      return next();
    } catch (e: any) {
      if (e instanceof ZodError) {
        const invalidError = new RequestValidationError(e.issues);
        return new ResponseAPI(res, {error: invalidError}).excute(
          invalidError.statusCode
        );
      }
      new ResponseAPI(res, {error: e}).excute(500);
    }
  };
}

export default zodValidate;
