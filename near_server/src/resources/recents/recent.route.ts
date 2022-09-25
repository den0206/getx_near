import {Router} from 'express';
import {z} from 'zod';
import checkAuth from '../../middleware/check_auth';
import zodValidate from '../../middleware/zod.middleware';
import {pagingQuery} from './../../middleware/validations/pagination';
import recentController from './recent.controller';

const recentRoute = Router();

recentRoute.get(
  '/userid',
  checkAuth,
  zodValidate(z.object(pagingQuery)),
  recentController.findByUserId
);

recentRoute.get('/roomId', checkAuth, recentController.findByRoomId);
recentRoute.get(
  '/userid/roomid',
  checkAuth,
  recentController.findByUserAndRoomid
);
recentRoute.post('/create', checkAuth, recentController.createChatRecent);

recentRoute.put('/', checkAuth, recentController.updateRecent);
recentRoute.delete('/delete', checkAuth, recentController.deleteRecent);

recentRoute.get('/badgeCount', checkAuth, recentController.getBadgCount);

export default recentRoute;
