import {Request, Response} from 'express';
import {RecentModel} from '../../utils/database/models';
import ResponseAPI from '../../utils/interface/response.api';
import {checkMongoId} from '../../utils/database/database';
import {usePagenation} from '../../utils/database/pagenation';
import mongoose from 'mongoose';

async function createChatRecent(req: Request, res: Response) {
  const {userId, chatRoomId, withUserId} = req.body;
  const newRecent = new RecentModel({chatRoomId, userId, withUserId});

  try {
    await newRecent.save();
    new ResponseAPI(res, {data: newRecent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function updateRecent(req: Request, res: Response) {
  const {recentId, lastMessage, counter} = req.body;

  if (!checkMongoId(recentId))
    return new ResponseAPI(res, {message: 'Invalid Id'}).excute(400);

  const value = {lastMessage, counter};
  try {
    const updateRecent = await RecentModel.findByIdAndUpdate(recentId, value, {
      new: true,
    });

    new ResponseAPI(res, {data: updateRecent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deleteRecent(req: Request, res: Response) {
  const {recentId} = req.body;
  if (!checkMongoId(recentId))
    return new ResponseAPI(res, {message: 'Invalid Id'}).excute(400);

  try {
    const del = await RecentModel.findByIdAndDelete(recentId);
    console.log('Success Delete');
    new ResponseAPI(res, {data: del}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByUserId(req: Request, res: Response) {
  const userId = res.locals.user.userId as string;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByRoomId(req: Request, res: Response) {
  const chatRoomId = req.query.chatRoomId;

  try {
    const recents = await RecentModel.find({chatRoomId}).populate([
      'userId',
      'withUserId',
    ]);

    new ResponseAPI(res, {data: recents}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function findByUserAndRoomid(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const chatRoomId = req.query.chatRoomId;

  try {
    const findRecent = await RecentModel.findOne({
      userId: userId,
      chatRoomId: chatRoomId,
    }).populate('userId withUserId');

    if (!findRecent)
      return new ResponseAPI(res, {message: 'Cant find'}).excute(400);

    new ResponseAPI(res, {data: findRecent}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getBadgCount(req: Request, res: Response) {
  const userId = res.locals.user.userId;

  try {
    const count = await RecentModel.aggregate([
      {$match: {userId: new mongoose.Types.ObjectId(userId)}},
      {$group: {_id: null, counter: {$sum: '$counter'}}},
    ]);

    if (count.length < 1) return new ResponseAPI(res, {data: 0}).excute(200);
    const total = count[0].counter as number;

    return res.status(200).json({status: true, data: total});
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
