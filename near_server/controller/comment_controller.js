const Comment = require('../model/comment');
const Post = require('../model/post');
const {checkId} = require('../db/database');
const base64 = require('../utils/base64');

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

    await newComment.save();
    await newComment.populate('userId', '-password');
    res.status(200).json({status: true, data: newComment});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function getUserTotalCommnets(req, res) {
  const userId = req.userData.userId;

  try {
    const comments = await Comment.find({postUserId: userId}).populate(
      'userId',
      '-password'
    );

    res.status(200).json({status: true, data: comments});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function getComment(req, res) {
  const {postId} = req.query;

  const cursor = req.query.cursor;
  const limit = +req.query.limit || 10;

  let query = {};
  if (cursor) {
    query['_id'] = {
      $lt: base64.decodeToBase64(cursor),
    };
  }

  try {
    let comments = await Comment.find({postId: postId})
      .sort({_id: -1})
      .limit(limit + 1)
      .populate('userId', '-password');

    const hasNextPage = comments.length > limit;
    comments = hasNextPage ? comments.slice(0, -1) : comments;
    const nextPageCursor = hasNextPage
      ? base64.encodeBase64(comments[comments.length - 1].id)
      : null;

    const data = {
      pageFeeds: comments,
      pageInfo: {nextPageCursor, hasNextPage},
    };

    res.status(200).json({status: true, data: data});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  addComment,
  getComment,
  getUserTotalCommnets,
};

/// relation でかける pre
// const findPostArray = await Post.findById(postId).select('comments');
//     if (!findPostArray)
//       return res
//         .status(400)
//         .json({status: false, message: 'Cant find the Post'});

//     var {comments} = findPostArray;

//     comments.unshift(newComment._id);
//     await Post.findByIdAndUpdate(postId, {comments: comments}, {new: true});

// const posts = await Post.find({userId: userId})
//   .select('comments')
//   .populate({
//     path: 'comments',
//     model: 'Comment',
//     populate: [
//       {path: 'userId', model: 'User', select: '-password'},
//       // {path: 'postId', model: 'Post'},
//     ],
//   });

// const comments = posts.flatMap((value) => {
//   return value.comments;
// });
