const TestPost = require('../model/test_post');

async function createPost(req, res) {
  const body = req.body;

  try {
    const newPost = TestPost({
      title: body.title,
      content: body.content,
      location: {type: 'Point', coordinates: [body.longitude, body.latitude]},
    });

    await newPost.save();
    res.status(200).json({status: true, data: newPost});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function getNearPost(req, res) {
  const q = req.query;

  const cood = [q.lng, q.lat];
  const radius = q.radius;

  const area = {center: cood, radius: radius, unique: true, spherical: false};

  try {
    const posts = await TestPost.find().where('location').near({
      center: cood,
      maxDistance: 100,
    });

    res.status(200).json({status: true, data: posts});
  } catch (e) {
    console.log(e);
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  createPost,
  getNearPost,
};

// const posts = await TestPost.find({
//   location: {
//     $near: {
//       $geometry: {
//         type: 'Point',
//         coordinates: [cood],
//       },
//       $maxDistance: maxDistance,
//     },
//   },
// });
