import {mongoose, prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';

export class Message {
  @prop({required: true})
  chatRoomId: string;
  @prop({required: true})
  text: string;
  @prop({ref: () => User})
  userId: Ref<User>;
  @prop({type: String, default: []})
  readBy: mongoose.Types.Array<string>;
  @prop({default: Date.now})
  date: Date;
}
