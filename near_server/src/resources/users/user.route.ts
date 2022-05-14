import {Router} from 'express';
import userController from './user.controller';
import checkAuth from '../../middleware/check_auth';

const usersRoute = Router();

usersRoute.post('/signup', userController.signUp);
usersRoute.post('/login', userController.login);

usersRoute.put('/location', checkAuth, userController.updateLocation);
export default usersRoute;
