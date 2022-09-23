import {Request, Response} from 'express';
import {commonErrorHandler} from '../../error/custom_error';
import InvalidMongoIDError from '../../error/errors/invalid_mongo_id';
import {checkMongoId} from '../../utils/database/database';
import {MessageModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';

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
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function sendTextMessage(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {chatRoomId, text} = req.body;
  try {
    const newMessage = new MessageModel({chatRoomId, text, userId});
    await newMessage.save();

    new ResponseAPI(res, {data: newMessage}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function updateMessage(req: Request, res: Response) {
  const {messageId, readBy} = req.body;

  if (!checkMongoId(messageId)) throw new InvalidMongoIDError();

  const value = {readBy};
  try {
    await MessageModel.findByIdAndUpdate(messageId, value);
    new ResponseAPI(res, {data: 'Update Successs'}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function deleteMessage(req: Request, res: Response) {
  const {messageId} = req.body;

  if (!checkMongoId(messageId)) throw new InvalidMongoIDError();

  try {
    const deleteMessage = await MessageModel.findByIdAndDelete(messageId);
    new ResponseAPI(res, {data: deleteMessage}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {loadMessage, sendTextMessage, updateMessage, deleteMessage};
