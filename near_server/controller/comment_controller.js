const Comment = require('../model/comment');
const Post = require('../model/post');
const {checkId} = require('../db/database');

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

    const findPostArray = await Post.findById(postId).select('comments');
    if (!findPostArray)
      return res
        .status(400)
        .json({status: false, message: 'Cant find the Post'});

    var {comments} = findPostArray;

    comments.unshift(newComment._id);
    console.log(comments);

    await newComment.save();
    const newPost = await Post.findByIdAndUpdate(
      postId,
      {comments: comments},
      {new: true}
    );

    res.status(200).json({status: true, data: newPost});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {
  addComment,
};
