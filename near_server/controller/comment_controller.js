const Comment = require('../model/comment');
const Post = require('../model/post');
const {checkId} = require('../db/database');
const res = require('express/lib/response');

async function addComment(req, res) {
  const userId = req.userData.userId;
  const {postId, text, longitude, latitude} = req.body;

  if (!checkId(postId))
    return res.status(400).json({status: false, message: 'Invalid Post Id'});

  try {
    const newComment = new Comment({
      text,
      userId,
      postId,
      location: {type: 'Point', coordinates: [longitude, latitude]},
    });

    /// relation でかける pre
    const findPostArray = await Post.findById(postId).select('comments');
    if (!findPostArray)
      return res
        .status(400)
        .json({status: false, message: 'Cant find the Post'});

    var {comments} = findPostArray;

    comments.unshift(newComment._id);

    await newComment.save();
    await Post.findByIdAndUpdate(postId, {comments: comments}, {new: true});

    await newComment.populate('userId', '-password');

    res.status(200).json({status: true, data: newComment});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

/// will pagination
async function getComment(req, res) {
  const {postId} = req.query;

  try {
    const comments = await Comment.find({postId: postId}).populate(
      'userId',
      '-password'
    );

    if (!comments)
      return res
        .status(400)
        .json({status: false, message: 'not find Comments'});

    res.status(200).json({status: true, data: comments});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  addComment,
  getComment,
};
