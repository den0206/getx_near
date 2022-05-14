import {Request, Response, NextFunction} from 'express';
import {AnyZodObject} from 'zod';
import ResponseAPI from '../utils/interface/response.api';

function zodValidate(schema: AnyZodObject) {
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
      return new ResponseAPI(res, {message: e.message}).excute(400);
    }
  };
}

export default zodValidate;
