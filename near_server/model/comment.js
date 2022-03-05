const mongoose = require(`mongoose`);

const location = require('./location');

const commentSchema = mongoose.Schema(
  {
    text: {type: String, required: true, maxlength: 50},
    postId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'Post'},
    postUserId: {type: String},
    userId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'},
    location: {type: location, required: true},
    expireAt: {
      type: Date,
      default: null,
    },
  },
  {timestamps: true}
);

commentSchema.pre('save', async function (next) {
  console.log('===== Relation Save');
  const Post = require('../model/post');
  const findPostArray = await Post.findById(
    this.postId,
    'userId comments expireAt'
  );

  if (!findPostArray) return next();

  var {userId, comments, expireAt} = findPostArray;
  /// 識別のためcomment SchemaにpostuserIdを付与
  this.postUserId = userId;
  ///
  this.expireAt = expireAt;
  comments.unshift(this._id);
  await Post.findByIdAndUpdate(this.postId, {comments: comments}, {new: true});

  next();
});

commentSchema.index({expireAt: 1}, {expireAfterSeconds: 0});
commentSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

commentSchema.set('toJSON', {
  virtuals: true,
});

const Comment = mongoose.model('Comment', commentSchema);
module.exports = Comment;

/// 何キロ離れているか確認(時間)
