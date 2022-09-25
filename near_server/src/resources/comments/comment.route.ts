import {Router} from 'express';
import {z} from 'zod';
import randomController from '../../helper/random/random.controller';
import checkAuth from '../../middleware/check_auth';
import {pagingPostIdQuery} from '../../middleware/validations/pagination';
import zodValidate from '../../middleware/zod.middleware';
import {pagingQuery} from './../../middleware/validations/pagination';
import commentController from './comment.controller';

const commentRoute = Router();

commentRoute.post('/add', checkAuth, commentController.addComment);

commentRoute.get(
  '/get',
  checkAuth,
  zodValidate(z.object(pagingPostIdQuery)),
  commentController.getComment
);
commentRoute.get(
  '/total',
  checkAuth,
  zodValidate(z.object(pagingQuery)),
  commentController.getUserRelationComments
);

commentRoute.get('/dummy', randomController.makeDummyComments);
export default commentRoute;
