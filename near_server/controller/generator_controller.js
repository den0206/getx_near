const Post = require('../model/post');
const User = require('../model/user');
const randomGenerator = require('../utils/random_generator');

async function makeDummy(req, res) {
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

      const loc = randomGenerator.locationR(lat, lng, radius);
      const {longitude, latitude} = loc;

      const newPost = Post({
        content: randomGenerator.idR(5),
        userId: dummyUser,
        emergency: randomGenerator.intR(101),
        location: {type: 'Point', coordinates: [longitude, latitude]},
      });

      return newPost;
    });
    res.status(200).json({status: true, data: result});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  makeDummy,
};
