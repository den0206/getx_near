import {Router} from 'express';
import userController from './user.controller';
import checkAuth from '../../middleware/check_auth';
import upload from '../../utils/aws/upload_option';

const usersRoute = Router();

usersRoute.post('/signup', upload.single('image'), userController.signUp);
usersRoute.post('/login', userController.login);

usersRoute.put(
  '/edit',
  checkAuth,
  upload.single('image'),
  userController.updateUser
);

usersRoute.put('/location', checkAuth, userController.updateLocation);
export default usersRoute;
