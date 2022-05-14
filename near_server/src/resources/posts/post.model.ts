import {prop, pre, Ref, index} from '@typegoose/typegoose';
import {User} from '../users/user.model';
import {Location} from '../../utils/interface/location';
import {Comment} from '../comments/comment.model';

@pre<Post>('remove', async function () {
  console.log('=== POST DELETE RELATION');
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
