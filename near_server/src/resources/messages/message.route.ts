import {Router} from 'express';
import {z} from 'zod';
import checkAuth from '../../middleware/check_auth';
import zodValidate from '../../middleware/zod.middleware';
import {pagingChatIdQuery} from './../../middleware/validations/pagination';
import messageController from './message.controller';

const messageRoute = Router();

messageRoute.get(
  '/load',
  checkAuth,
  zodValidate(z.object(pagingChatIdQuery)),
  messageController.loadMessage
);
messageRoute.post('/text', checkAuth, messageController.sendTextMessage);
messageRoute.put('/update', messageController.updateMessage);
messageRoute.delete('/delete', checkAuth, messageController.deleteMessage);

export default messageRoute;
