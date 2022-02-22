const mongoose = require(`mongoose`);
const location = require('./location');
const Comment = require('./comment');

const postSchema = mongoose.Schema({
  title: {type: String},
  content: {type: String, required: true, maxlength: 160},
  userId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'},
  emergency: {type: Number, required: true},
  comments: [
    {type: mongoose.Schema.Types.ObjectId, ref: 'Comment', default: []},
  ],
  location: {
    type: location,
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
});

/// Post Delete Relation

postSchema.pre('remove', async function (next) {
  await Comment.deleteMany({postId: this._id});
  next();
});

postSchema.index({location: '2dsphere'});
postSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

postSchema.set('toJSON', {
  virtuals: true,
});

const Post = mongoose.model('Post', postSchema);
module.exports = Post;
