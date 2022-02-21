const mongoose = require(`mongoose`);

const userSchema = mongoose.Schema({
  name: {type: String, required: true, maxlength: 20},
  email: {type: String, required: true, unique: true},
  avatarUrl: {type: String},
  password: {type: String, required: true},
});

userSchema.virtual('id').get(function () {
  if (this._id) return this._id.toHexString();
});

userSchema.set('toJSON', {
  virtuals: true,
});

const User = mongoose.model('User', userSchema);
module.exports = User;
