import {Router} from 'express';
import userController from './user.controller';

const usersRoute = Router();

usersRoute.post('/signup', userController.signUp);
usersRoute.post('/login', userController.login);

export default usersRoute;
