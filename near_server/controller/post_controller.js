const Post = require('../model/post');
const GeoJSON = require(`mongoose-geojson-schema`);

async function createPost(req, res) {
  const body = req.body;

  try {
    const newPost = Post({
      title: body.title,
      content: body.content,
      userId: body.userId,
      emergency: body.emergency,
      location: {type: 'Point', coordinates: [body.longitude, body.latitude]},
    });

    await newPost.save();
    await newPost.populate('userId', '-password');
    res.status(200).json({status: true, data: newPost});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function getNearPost(req, res) {
  const q = req.query;

  const cood = [q.lng, q.lat];
  const radius = q.radius;

  try {
    const posts = await Post.find({
      location: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: cood,
          },
          $maxDistance: parseInt(radius),
        },
      },
    }).populate('userId', '-password');

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

// const area = {center: cood, radius: radius, unique: true, spherical: true};
// const posts = await Post.find().where('location').within().circle(area);
