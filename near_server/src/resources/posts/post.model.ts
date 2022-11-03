import {index, pre, prop, Ref} from '@typegoose/typegoose';
import {CommentModel} from '../../utils/database/models';
import {Location} from '../../utils/interface/location';
import {Comment} from '../comments/comment.model';
import {User} from '../users/user.model';

@pre<Post>('remove', async function (next) {
  await CommentModel.deleteMany({postId: this._id});

  console.log('=== POST DELETE RELATION');
  next();
})
@index({location: '2dsphere'})
@index({expireAt: 1}, {expireAfterSeconds: 0})
export class Post {
  @prop()
  title: string;
  @prop({required: true, maxlength: 160})
  content: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({required: true})
  emergency: number;
  @prop({default: null})
  expireAt: Date;
  @prop({default: Date.now})
  createdAt: Date;
  @prop({required: true, _id: false})
  location: Location;
  @prop({default: [], ref: () => User})
  likes: Ref<User>[];
  @prop({default: [], ref: () => Comment})
  comments: Ref<Comment>[];
}
