import {Request, Response} from 'express';
import {MessageModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';
import {checkMongoId} from '../../utils/database/database';

async function loadMessage(req: Request, res: Response) {
  const chatRoomId = req.query.chatRoomId;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

  try {
    const data = await usePagenation({
      model: MessageModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {chatRoomId},
    });

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function sendTextMessage(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {chatRoomId, text} = req.body;
  try {
    const newMessage = new MessageModel({chatRoomId, text, userId});
    await newMessage.save();

    new ResponseAPI(res, {data: newMessage}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateMessage(req: Request, res: Response) {
  const {messageId, readBy} = req.body;

  if (!checkMongoId(messageId))
    return new ResponseAPI(res, {message: 'Invalid Id'}).excute(400);

  const value = {readBy};
  try {
    await MessageModel.findByIdAndUpdate(messageId, value);
    new ResponseAPI(res, {data: 'Update Successs'}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteMessage(req: Request, res: Response) {
  const {messageId} = req.body;

  if (!checkMongoId(messageId))
    return new ResponseAPI(res, {message: 'Invalid Id'}).excute(400);

  try {
    const deleteMessage = await MessageModel.findByIdAndDelete(messageId);
    new ResponseAPI(res, {data: deleteMessage}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {loadMessage, sendTextMessage, updateMessage, deleteMessage};
