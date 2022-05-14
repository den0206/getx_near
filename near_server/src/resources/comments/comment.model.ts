import {prop, pre, Ref, index} from '@typegoose/typegoose';
import {Post} from '../posts/post.model';
import {User} from '../users/user.model';
import {Location} from '../../utils/interface/location';
import {PostModel} from '../../utils/database/models';

@pre<Comment>('save', async function (next) {
  console.log('===== Relation Save');
  //   const PostModel = require('../model/post');
  var findPostArray = await PostModel.findById(
    this.postId,
    'userId comments expireAt'
  );

  if (!findPostArray) return next();

  var {comments, expireAt} = findPostArray;
  this.expireAt = expireAt;
  comments.unshift(this._id);
  await PostModel.findByIdAndUpdate(
    this.postId,
    {comments: comments},
    {new: true}
  );

  console.log(comments);
  next();
})
@index({expireAt: 1}, {expireAfterSeconds: 0})
export class Comment {
  @prop({required: true, maxlength: 50})
  text: string;
  @prop({required: true, ref: () => Post})
  postId: Ref<Post>;
  @prop()
  postUserId: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({required: true, _id: false})
  location: Location;
  @prop({default: null})
  expireAt: Date;
}
