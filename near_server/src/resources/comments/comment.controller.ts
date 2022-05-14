import {Request, Response} from 'express';
import {checkMongoId} from '../../utils/database/database';
import ResponseAPI from '../../utils/interface/response.api';
import {CommentModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';

async function addComment(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {postId, text, longitude, latitude} = req.body;
  if (!checkMongoId(postId))
    return new ResponseAPI(res, {message: 'Invalid PotId'}).excute(400);

  try {
    const newComment = new CommentModel({
      text,
      userId,
      postId,
      location: {type: 'Point', coordinates: [longitude, latitude]},
    });

    await newComment.save();
    await newComment.populate('userId', '-password');
    return new ResponseAPI(res, {data: newComment}).excute(200);
  } catch (e: any) {
    return new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getUserTotalComments(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;
  try {
    const data = await usePagenation({
      model: CommentModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {userId},
    });
    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getComment(req: Request, res: Response) {
  const postId = req.query.postId as string;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

  try {
    const data = await usePagenation({
      model: CommentModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {postId},
    });

    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {
  addComment,
  getComment,
  getUserTotalComments,
};
