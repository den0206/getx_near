const mongoose = require('mongoose');
var uniqueValidator = require('mongoose-unique-validator');

const recentSchema = mongoose.Schema(
  {
    chatRoomId: {type: String, required: true},
    userId: {type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true},
    withUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    lastMessage: {type: String, default: ''},
    conter: {type: Number, default: 0},
  },
  {timestamps: true}
);

recentSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

recentSchema.set('toJSON', {
  virtuals: true,
});
recentSchema.plugin(uniqueValidator);

const Recent = mongoose.model('Recent', recentSchema);
module.exports = Recent;
