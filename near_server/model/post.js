const mongoose = require(`mongoose`);

const postSchema = mongoose.Schema({
  title: {type: String},
  content: {type: String, required: true, maxlength: 160},
  userId: {type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User'},
  emergency: {type: Number, required: true},
  location: {
    type: {
      type: String,
      enum: ['Point'],
      required: true,
    },
    coordinates: {
      type: [Number],
      required: true,
    },
  },
  createdAt: {
    type: Date,
    default: Date.now,
    expires: 3600,
  },
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
