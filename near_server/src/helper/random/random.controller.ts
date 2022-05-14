import randomGenerator from './random.generator';
import {Request, Response} from 'express';
import ResponseAPI from '../../utils/interface/response.api';
import {UserModel, PostModel, CommentModel} from '../../utils/database/models';

async function makeDummyPosts(req: Request, res: Response) {
  const lng = parseFloat(req.query.lng as string);
  const lat = parseFloat(req.query.lat as string);
  const radius = parseInt(req.query.radius as string);
  const randomNum = randomGenerator.intR(20);

  try {
    const result = [...Array(randomNum)].map((_, i) => {
      const dummyUser = new UserModel({
        name: `Sample${i}`,
        email: 'sample@email.com',
        password: '12345',
      });

      var expireAt = new Date();
      expireAt.setHours(expireAt.getHours() + 3);

      const loc = randomGenerator.locationR(lat, lng, radius);

      const {longitude, latitude} = loc;
      const newPost = new PostModel({
        content: randomGenerator.idR(200),
        userId: dummyUser,
        emergency: randomGenerator.intR(101),
        expireAt: expireAt,
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      return newPost;
    });
    new ResponseAPI(res, {data: result}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function makeDummyComments(req: Request, res: Response) {
  const {postId} = req.query;
  const lng = parseFloat(req.query.lng as string);
  const lat = parseFloat(req.query.lat as string);
  const radius = parseInt(req.query.radius as string);
  const randomNum = randomGenerator.intR(10);

  try {
    const result = [...Array(randomNum)].map((_, i) => {
      const userId = new UserModel({
        name: `Sample${i}`,
        email: 'sample@email.com',
        password: '12345',
      });

      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;
      const text = randomGenerator.idR(100);
      const createdAt = Date.now();

      const newComment = new CommentModel({
        text,
        userId,
        postId,
        createdAt,
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      return newComment;
    });
    new ResponseAPI(res, {data: result}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

async function makeDummyMyPosts(req: Request, res: Response) {
  const userId = res.locals.user.userId;

  const lng = parseFloat(req.query.lng as string);
  const lat = parseFloat(req.query.lat as string);
  const radius = parseInt(req.query.radius as string);

  try {
    const findUser = await UserModel.findById(userId).select('-password');

    if (!findUser)
      return new ResponseAPI(res, {message: 'No Find User'}).excute(400);

    const userLength = randomGenerator.intR(20) + 1;

    const dummyUsers = [...Array(userLength)].map((_, i) => {
      const user = new UserModel({
        name: `Sample${i}`,
        email: 'sample@email.com',
        password: '12345',
      });

      return user;
    });

    const postLength = randomGenerator.intR(30);
    var expireAt = new Date();
    expireAt.setHours(expireAt.getHours() + 3);

    let posts = [...Array(postLength)].map((_, i) => {
      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;
      const newPost = new PostModel({
        content: randomGenerator.idR(200),
        userId: findUser,
        emergency: randomGenerator.intR(101),
        expireAt: expireAt,
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      /// dummy Liks

      const likeLength =
        dummyUsers.length - randomGenerator.intR(dummyUsers.length);
      const likes = dummyUsers.map((user) => user.id).slice(0, likeLength - 1);

      /// dummy Comment
      const commentLength = randomGenerator.intR(20);
      const comments = [...Array(commentLength)].map((_, id) => {
        const commentLoc = randomGenerator.locationR(
          latitude,
          longitude,
          radius
        );
        const newComment = new CommentModel({
          text: randomGenerator.idR(100),
          userId: randomGenerator.randomObjFromArray(dummyUsers),
          postId: newPost.id,
          expireAt: expireAt,
          location: {
            type: 'Point',
            coordinates: [commentLoc.longitude, commentLoc.latitude],
          },
        });

        return newComment;
      });

      newPost.comments = comments.map((comment) => comment.id);
      newPost.likes = likes;

      return newPost;
    });

    new ResponseAPI(res, {data: posts}).excute(200);
  } catch (e: any) {
    new ResponseAPI(res, {message: e.message}).excute(500);
  }
}

export default {
  makeDummyPosts,
  makeDummyMyPosts,
  makeDummyComments,
};
