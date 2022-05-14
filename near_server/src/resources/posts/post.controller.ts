import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';
import {PostModel, UserModel} from '../../utils/database/models';
import {usePagenation} from '../../utils/database/pagenation';
import {checkMongoId} from '../../utils/database/database';

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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

// experiment
async function createPostWithNearUser(req: Request, res: Response) {
  const {title, content, emergency, expireAt, longitude, latitude} = req.body;
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
          $maxDistance: 5000,
        },
      },
    }).limit(30);

    const data = {newPost, nearUsers};

    new ResponseAPI(res, {data}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function getMyPosts(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const cursor = req.query.cursor as string;
  const limit: number = parseInt(req.query.limit as string) || 10;

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
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function addLike(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const postId = req.body.postId as string;

  console.log(postId);

  try {
    const getLikes = await PostModel.findById(postId).select('likes');
    if (!getLikes)
      return new ResponseAPI(res, {message: 'Can not fint The Post'}).excute(
        404
      );

    var {likes} = getLikes;
    console.log(likes);

    if (likes.includes(userId)) {
      likes = likes.filter((id) => id!.toString() !== userId);
    } else {
      likes.push(userId);
    }

    await PostModel.findByIdAndUpdate(postId, {likes}, {new: true});

    new ResponseAPI(res, {data: likes}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function deletePost(req: Request, res: Response) {
  const userId = res.locals.user.userId;
  const postId = req.body.postId as string;

  console.log(postId);

  if (!checkMongoId(postId))
    new ResponseAPI(res, {message: 'Invalid id'}).excute(400);

  const findPost = await PostModel.findById(postId);

  if (!findPost || findPost.userId != userId)
    return new ResponseAPI(res, {message: 'Cant delete this post'}).excute(400);

  try {
    /// delete with pre reletaion
    await findPost.delete();

    console.log('=== Complete DELETE');
    new ResponseAPI(res, {data: findPost}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
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
