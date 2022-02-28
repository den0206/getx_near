const Post = require('../model/post');
const mongoose = require('mongoose');
const GeoJSON = require(`mongoose-geojson-schema`);
const base64 = require('../utils/base64');

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
    })
      .limit(100)
      .populate('userId', '-password');

    res.status(200).json({status: true, data: posts});
  } catch (e) {
    console.log(e);
    res.status(500).json({status: false, message: e.message});
  }
}
async function getMyPosts(req, res) {
  const userId = req.query.userId;

  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {userId: userId};
  if (cursor) {
    query['_id'] = {
      $lt: base64.decodeToBase64(cursor),
    };
  }

  try {
    let posts = await Post.find(query)
      .sort({_id: -1})
      .limit(limit + 1)
      .populate('userId', '-password');

    const hasNextPage = posts.length > limit;
    posts = hasNextPage ? posts.slice(0, -1) : posts;
    const nextPageCursor = hasNextPage
      ? base64.encodeBase64(posts[posts.length - 1].id)
      : null;

    const data = {
      pageFeeds: posts,
      pageInfo: {nextPageCursor, hasNextPage},
    };

    res.status(200).json({status: true, data: data});
  } catch (e) {
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
  getMyPosts,
  addLike,
};

// const area = {center: cood, radius: radius, unique: true, spherical: true};
// const posts = await Post.find().where('location').within().circle(area);
