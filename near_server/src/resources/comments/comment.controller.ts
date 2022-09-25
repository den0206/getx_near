import {Request, Response} from 'express';
import {commonErrorHandler} from '../../error/custom_error';
import InvalidMongoIDError from '../../error/errors/invalid_mongo_id';
import {
  PagingQuery,
  PagingWithPostIdQuery,
} from '../../middleware/validations/pagination';
import {checkMongoId} from '../../utils/database/database';
import {CommentModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';

async function addComment(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const {postId, text, postUserId, longitude, latitude} = req.body;
  if (!checkMongoId(postId)) throw new InvalidMongoIDError();
  try {
    const newComment = new CommentModel({
      text,
      userId,
      postId,
      postUserId,
      location: {type: 'Point', coordinates: [longitude, latitude]},
    });

    await newComment.save();
    await newComment.populate('userId', '-password');
    new ResponseAPI(res, {data: newComment}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getComment(
  req: Request<{}, {}, {}, PagingWithPostIdQuery>,
  res: Response
) {
  const postId = req.query.postId;
  const cursor = req.query.cursor;
  const limit: number = parseInt(req.query.limit ?? '10');
  try {
    const data = await usePagenation({
      model: CommentModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {postId},
    });

    // コメント数の取得
    const count = await CommentModel.countDocuments({postId});

    const result = {count: count, pages: data};

    new ResponseAPI(res, {data: result}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getUserRelationComments(
  req: Request<{}, {}, {}, PagingQuery>,
  res: Response
) {
  const userId = res.locals.user.userId;
  const cursor = req.query.cursor;
  const limit: number = parseInt(req.query.limit ?? '10');

  try {
    const data = await usePagenation({
      model: CommentModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {postUserId: userId},
    });
    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {
  addComment,
  getComment,
  getUserRelationComments,
};
