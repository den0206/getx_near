import {mongoose, prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';

export class Message {
  @prop({type: () => String, required: true})
  chatRoomId: string;
  @prop({type: () => String, required: true})
  text: string;
  @prop({ref: () => User})
  userId: Ref<User>;
  @prop({type: String, default: []})
  readBy: mongoose.Types.Array<string>;
  @prop({type: () => Date, default: Date.now})
  date: Date;
}
