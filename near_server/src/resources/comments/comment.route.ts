import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import commentController from './comment.controller';
import randomController from '../../helper/random/random.controller';

const commentRoute = Router();

commentRoute.post('/add', checkAuth, commentController.addComment);
commentRoute.get('/get', checkAuth, commentController.getComment);
commentRoute.get(
  '/total',
  checkAuth,
  commentController.getUserRelationComments
);

commentRoute.get('/dummy', randomController.makeDummyComments);
export default commentRoute;
