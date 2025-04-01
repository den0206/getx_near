import {index, pre, prop, Ref} from '@typegoose/typegoose';
import {CommentModel} from '../../utils/database/models';
import {Location} from '../../utils/interface/location';
import {Comment} from '../comments/comment.model';
import {User} from '../users/user.model';

@pre<Post>(
  'deleteOne',
  async function (next) {
    await CommentModel.deleteMany({postId: (await this)._id});

    console.log('=== POST DELETE RELATION');
    next();
  },
  {document: true, query: true}
)
@index({location: '2dsphere'})
@index({expireAt: 1}, {expireAfterSeconds: 0})
export class Post {
  @prop({type: () => String})
  title: string;
  @prop({type: () => String, required: true, maxlength: 160})
  content: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({type: () => Number, required: true})
  emergency: number;
  @prop({type: () => Date, default: null})
  expireAt: Date;
  @prop({type: () => Date, default: Date.now})
  createdAt: Date;
  @prop({type: () => Location, required: true, _id: false})
  location: Location;
  @prop({default: [], ref: () => User})
  likes: Ref<User>[];
  @prop({default: [], ref: () => Comment})
  comments: Ref<Comment>[];
}
