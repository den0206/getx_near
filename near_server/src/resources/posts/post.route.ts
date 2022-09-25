import {Router} from 'express';
import {z} from 'zod';
import randomController from '../../helper/random/random.controller';
import checkAuth from '../../middleware/check_auth';
import zodValidate from '../../middleware/zod.middleware';
import {pagingQuery} from './../../middleware/validations/pagination';
import postController from './post.controller';

const postRoute = Router();

postRoute.post('/create', checkAuth, postController.createPostWithNearUser);
postRoute.get('/near', postController.getNearPost);

postRoute.get(
  '/myposts',
  checkAuth,
  zodValidate(z.object(pagingQuery)),
  postController.getMyPosts
);

postRoute.put('/like', checkAuth, postController.addLike);
postRoute.delete('/delete', checkAuth, postController.deletePost);

postRoute.get('/dummy/all', randomController.makeDummyPosts);
postRoute.get('/dummy/my', checkAuth, randomController.makeDummyMyPosts);
export default postRoute;
