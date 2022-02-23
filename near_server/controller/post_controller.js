const Post = require('../model/post');
const mongoose = require('mongoose');
const GeoJSON = require(`mongoose-geojson-schema`);

async function createPost(req, res) {
  const body = req.body;
  const userId = req.userData.userId;

  try {
    const newPost = Post({
      title: body.title,
      content: body.content,
      userId: userId,
      emergency: body.emergency,
      expireAt: body.expireAt,
      location: {type: 'Point', coordinates: [body.longitude, body.latitude]},
    });

    await newPost.save();
    await newPost.populate('userId', '-password');
    res.status(200).json({status: true, data: newPost});
  } catch (e) {
    console.log(e.message);
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

async function addLike(req, res) {
  const userId = req.userData.userId;
  const {postId} = req.body;
  try {
    const get = await Post.findById(postId).select('likes');
    if (!get)
      return res
        .status(400)
        .json({status: false, message: 'Can not fint The Post'});

    var {likes} = get;
    console.log(likes);

    if (likes.includes(userId)) {
      likes = likes.filter((id) => id.toString() !== userId);
    } else {
      likes.push(userId);
    }

    const newPost = await Post.findByIdAndUpdate(postId, {likes}, {new: true});
    res.status(200).json({status: true, data: newPost.likes});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  createPost,
  getNearPost,
  addLike,
};

// const area = {center: cood, radius: radius, unique: true, spherical: true};
// const posts = await Post.find().where('location').within().circle(area);
