import {prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';

export class Recent {
  @prop({type: () => String, required: true})
  chatRoomId: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({required: true, ref: () => User})
  withUserId: Ref<User>;
  @prop({type: () => String, default: ''})
  lastMessage: string;
  @prop({type: () => Number, default: 0})
  counter: number;
}
