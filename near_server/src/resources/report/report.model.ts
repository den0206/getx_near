import {index, pre, prop, Ref} from '@typegoose/typegoose';
import {Message} from '../messages/message.model';
import {Post} from '../posts/post.model';
import {User} from '../users/user.model';
@pre<Report>('save', async function (next) {
  // 一ヶ月後に削除
  const expire = new Date();
  expire.setMonth(expire.getMonth() + 1);
  this.expireAt = expire;

  next();
})
@index({expireAt: 1}, {expireAfterSeconds: 0})
export class Report {
  @prop({required: true, ref: () => User})
  informer: Ref<User>;
  @prop({required: true, ref: () => User})
  reported: Ref<User>;
  @prop({ref: () => Message})
  message: Ref<Message>;
  @prop({ref: () => Post})
  post: Ref<Post>;
  @prop({required: true})
  reportedContent: string;
  @prop({default: null})
  expireAt: Date;
}
