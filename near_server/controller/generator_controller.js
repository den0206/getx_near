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
      // expireAt.setHours(expireAt.getHours() + 3);
      expireAt.setSeconds(expireAt.getSeconds() + 20);

      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;

      const newPost = Post({
        content: randomGenerator.idR(5),
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
      const text = randomGenerator.idR(50);
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

module.exports = {
  makeDummyPosts,
  makeDummyComments,
};
