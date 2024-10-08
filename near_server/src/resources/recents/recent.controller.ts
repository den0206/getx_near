import {Request, Response} from 'express';
import mongoose from 'mongoose';
import {commonErrorHandler} from '../../error/custom_error';
import InvalidMongoIDError from '../../error/errors/invalid_mongo_id';
import NotFoundRecentError from '../../error/errors/not_find_recent';
import {PagingQuery} from '../../middleware/validations/pagination';
import {checkMongoId} from '../../utils/database/database';
import {RecentModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';

async function createChatRecent(req: Request, res: Response) {
  const {userId, chatRoomId, withUserId} = req.body;
  const newRecent = new RecentModel({chatRoomId, userId, withUserId});

  try {
    await newRecent.save();
    new ResponseAPI(res, {data: newRecent}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function updateRecent(req: Request, res: Response) {
  const {recentId, lastMessage, counter} = req.body;

  if (!checkMongoId(recentId)) throw new InvalidMongoIDError();

  const value = {lastMessage, counter};
  try {
    const updateRecent = await RecentModel.findByIdAndUpdate(recentId, value, {
      new: true,
    });

    new ResponseAPI(res, {data: updateRecent}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function deleteRecent(req: Request, res: Response) {
  const {recentId} = req.body;
  if (!checkMongoId(recentId)) throw new InvalidMongoIDError();

  try {
    const del = await RecentModel.findByIdAndDelete(recentId);
    console.log('Success Delete');
    new ResponseAPI(res, {data: del}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function findByUserId(
  req: Request<{}, {}, {}, PagingQuery>,
  res: Response
) {
  const userId = res.locals.user.userId as string;
  const cursor = req.query.cursor;
  const limit: number = parseInt(req.query.limit ?? '10');

  console.log(userId, cursor, limit);

  try {
    const data = await usePagenation({
      model: RecentModel,
      limit,
      cursor,
      populate: 'userId withUserId',
      specific: {userId},
    });

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function findByRoomId(req: Request, res: Response) {
  const chatRoomId = req.query.chatRoomId as string;

  try {
    const recents = await RecentModel.find({chatRoomId}).populate([
      'userId',
      'withUserId',
    ]);

    new ResponseAPI(res, {data: recents}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function findByUserAndRoomid(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const chatRoomId = req.query.chatRoomId as string;

  try {
    const findRecent = await RecentModel.findOne({
      userId: userId,
      chatRoomId: chatRoomId,
    }).populate('userId withUserId');

    if (!findRecent) throw new NotFoundRecentError();

    new ResponseAPI(res, {data: findRecent}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getBadgCount(req: Request, res: Response) {
  const userId = req.query.userId as string;

  try {
    const count = await RecentModel.aggregate([
      {$match: {userId: new mongoose.Types.ObjectId(userId)}},
      {$group: {_id: null, counter: {$sum: '$counter'}}},
    ]);

    if (count.length < 1) return new ResponseAPI(res, {data: 0}).excute(200);
    const total = count[0].counter as number;

    return new ResponseAPI(res, {data: total}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {
  createChatRecent,
  updateRecent,
  deleteRecent,
  findByUserId,
  findByRoomId,
  findByUserAndRoomid,
  getBadgCount,
};
