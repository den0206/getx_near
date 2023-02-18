import {Request, Response} from 'express';
import {commonErrorHandler} from '../../error/custom_error';
import InvalidMongoIDError from '../../error/errors/invalid_mongo_id';
import NotDeletePostError from '../../error/errors/not_delete_post';
import NotFoundUserError from '../../error/errors/not_find_user';
import {PagingQuery} from '../../middleware/validations/pagination';
import {checkMongoId} from '../../utils/database/database';
import {PostModel, UserModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import ResponseAPI from '../../utils/interface/response.api';

async function createPost(req: Request, res: Response) {
  const {title, content, emergency, expireAt, longitude, latitude} = req.body;
  const userId = res.locals.user.userId;

  try {
    const newPost = new PostModel({
      title,
      content,
      userId,
      emergency,
      expireAt,
      location: {type: 'Point', coordinates: [longitude, latitude]},
    });
    await newPost.populate('userId', '-password');
    await newPost.save();
    new ResponseAPI(res, {data: newPost}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

// experiment
async function createPostWithNearUser(req: Request, res: Response) {
  const {
    title,
    content,
    emergency,
    maxDistance,
    expireAt,
    longitude,
    latitude,
  } = req.body;
  const userId = res.locals.user.userId;
  const cood = [longitude, latitude];
  try {
    const newPost = new PostModel({
      title,
      content,
      userId,
      emergency,
      expireAt,
      location: {type: 'Point', coordinates: cood},
    });
    await newPost.populate('userId', '-password');
    await newPost.save();

    const nearUsers = await UserModel.find({
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: cood,
          },
          $maxDistance: parseInt(maxDistance as string),
        },
      },
    })
      .select('fcmToken')
      .limit(20);

    const tokens = nearUsers.map(({fcmToken}) => fcmToken);

    const data = {newPost, tokens};

    new ResponseAPI(res, {data}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getNearPost(req: Request, res: Response) {
  const {lng, lat, radius} = req.query;
  const cood = [lng, lat];

  try {
    const posts = await PostModel.find({
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: cood,
          },
          $maxDistance: parseInt(radius as string),
        },
      },
    })
      .limit(100)
      .populate('userId', '-password');

    new ResponseAPI(res, {data: posts}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function getMyPosts(
  req: Request<{}, {}, {}, PagingQuery>,
  res: Response
) {
  const userId = res.locals.user.userId;
  const cursor = req.query.cursor;
  const limit: number = parseInt(req.query.limit ?? '10');

  try {
    const data = await usePagenation({
      model: PostModel,
      limit,
      cursor,
      populate: 'userId',
      exclued: '-password',
      specific: {userId},
    });
    new ResponseAPI(res, {data: data}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function addLike(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const postId = req.body.postId as string;

  console.log(postId);

  try {
    const getLikes = await PostModel.findById(postId).select('likes');

    if (!getLikes) throw new NotFoundUserError();

    let {likes} = getLikes;
    console.log(likes);

    if (likes.includes(userId)) {
      likes = likes.filter((id) => id.toString() !== userId);
    } else {
      likes.push(userId);
    }

    await PostModel.findByIdAndUpdate(postId, {likes}, {new: true});

    new ResponseAPI(res, {data: likes}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

async function deletePost(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const postId = req.body.postId as string;

  console.log(postId);

  if (!checkMongoId(postId)) throw new InvalidMongoIDError();

  const findPost = await PostModel.findById(postId);

  if (!findPost || findPost.userId != userId) throw new NotDeletePostError();

  try {
    /// delete with pre reletaion
    await findPost.delete();

    console.log('=== Complete DELETE');
    new ResponseAPI(res, {data: findPost}).excute(200);
  } catch (e) {
    commonErrorHandler(res, e);
  }
}

export default {
  createPost,
  getNearPost,
  getMyPosts,
  addLike,
  deletePost,
  createPostWithNearUser,
};
