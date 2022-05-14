import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import postController from './post.controller';
import randomController from '../../helper/random/random.controller';

const postRoute = Router();

postRoute.post('/create', checkAuth, postController.createPostWithNearUser);
postRoute.get('/near', postController.getNearPost);
postRoute.get('/myposts', checkAuth, postController.getMyPosts);
postRoute.put('/like', checkAuth, postController.addLike);
postRoute.delete('/delete', checkAuth, postController.deletePost);

postRoute.get('/dummy/all', randomController.makeDummyPosts);
postRoute.get('/dummy/my', checkAuth, randomController.makeDummyMyPosts);
export default postRoute;
