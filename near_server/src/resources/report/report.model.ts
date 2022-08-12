import {prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';
import {Message} from '../messages/message.model';
import {Post} from '../posts/post.model';

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
}
