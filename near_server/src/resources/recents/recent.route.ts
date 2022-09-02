import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import recentController from './recent.controller';

const recentRoute = Router();

recentRoute.get('/userid', checkAuth, recentController.findByUserId);
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
