import {index, pre, prop, Ref} from '@typegoose/typegoose';
import {PostModel} from '../../utils/database/models';
import {Location} from '../../utils/interface/location';
import {Post} from '../posts/post.model';
import {User} from '../users/user.model';

@pre<Comment>('save', async function (next) {
  console.log('===== Relation Save');
  const findPostArray = await PostModel.findById(
    this.postId,
    'userId comments expireAt'
  );

  if (!findPostArray) {
    const expire = new Date();
    expire.setHours(expire.getHours() + 3);
    this.expireAt = expire;
    return next();
  }

  const {comments, expireAt} = findPostArray;

  // // utc to iso
  // let isoString = expireAt.toISOString();
  // let isoDate = new Date(isoString);
  // console.log(isoDate);

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
@index({location: '2dsphere'})
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
