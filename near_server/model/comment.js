const mongoose = require(`mongoose`);
const location = require('./location');

const commentSchema = mongoose.Schema(
  {
    text: {type: String, required: true, maxlength: 50},
    postId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'Post'},
    userId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'},
    location: {type: location, required: true},
  },
  {timestamps: true}
);

commentSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

commentSchema.set('toJSON', {
  virtuals: true,
});

const Comment = mongoose.model('Comment', commentSchema);
module.exports = Comment;

/// 何キロ離れているか確認(時間)
