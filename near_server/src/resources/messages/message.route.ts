import {Router} from 'express';
import checkAuth from '../../middleware/check_auth';
import messageController from './message.controller';

const messageRoute = Router();

messageRoute.get('/load', checkAuth, messageController.loadMessage);
messageRoute.post('/text', checkAuth, messageController.sendTextMessage);
messageRoute.put('/update', messageController.updateMessage);
messageRoute.delete('/delete', checkAuth, messageController.deleteMessage);

export default messageRoute;
