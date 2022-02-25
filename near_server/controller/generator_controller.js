const Post = require('../model/post');
const User = require('../model/user');
const Comment = require('../model/comment');

const randomGenerator = require('../utils/random_generator');

async function makeDummyPosts(req, res) {
  const query = req.query;
  const {lng, lat} = query;
  const radius = query.radius;

  const randomNum = randomGenerator.intR(20);

  try {
    const result = [...Array(randomNum)].map((_, i) => {
      const dummyUser = User({
        name: `Sample${i}`,
        email: 'sample@email.com',
        password: '12345',
      });

      var expireAt = new Date();
      expireAt.setHours(expireAt.getHours() + 3);
      // expireAt.setSeconds(expireAt.getSeconds() + 20);

      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;

      const newPost = Post({
        content: randomGenerator.idR(200),
        userId: dummyUser,
        emergency: randomGenerator.intR(101),
        expireAt: expireAt,
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      return newPost;
    });
    res.status(200).json({status: true, data: result});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function makeDummyComments(req, res) {
  const {postId, lng, lat, radius} = req.query;
  const randomNum = randomGenerator.intR(10);

  try {
    const result = [...Array(randomNum)].map((_, i) => {
      const userId = User({
        name: `Sample${i}`,
        email: 'sample@email.com',
        password: '12345',
      });

      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;
      const text = randomGenerator.idR(100);
      const createdAt = Date.now();

      const newComment = new Comment({
        text,
        userId,
        postId,
        createdAt,
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      return newComment;
    });
    res.status(200).json({status: true, data: result});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function makeDummyMyPosts(req, res) {
  const userId = req.userData.userId;
  const {lng, lat, radius} = req.query;

  try {
    const findUser = await User.findById(userId).select('-password');

    if (!findUser)
      return res.status(400).json({status: false, message: 'Not find User'});

    const userLength = randomGenerator.intR(20) + 1;

    const dummyUsers = [...Array(userLength)].map((_, i) => {
      const user = User({
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
      const newPost = Post({
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
        const newComment = new Comment({
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

    res.status(200).json({status: true, data: posts});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  makeDummyPosts,
  makeDummyMyPosts,
  makeDummyComments,
};
