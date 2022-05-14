import {prop, Ref} from '@typegoose/typegoose';
import {User} from '../users/user.model';

export class Recent {
  @prop({required: true})
  chatRoomId: string;
  @prop({required: true, ref: () => User})
  userId: Ref<User>;
  @prop({required: true, ref: () => User})
  withUserId: Ref<User>;
  @prop({default: ''})
  lastMessage: string;
  @prop({default: 0})
  counter: number;
}
