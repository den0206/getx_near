import {prop, pre, index} from '@typegoose/typegoose';
import argon2 from 'argon2';
import {Location} from '../../utils/interface/location';

@pre<User>('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);

    this.password = hashed;
  }
  return next();
})
@index({location: '2dsphere'})
export class User {
  @prop({required: true, maxlength: 20})
  name: string;
  @prop({required: true, unique: true})
  email: string;
  @prop()
  avatarUrl: string;
  @prop({required: true})
  password: string;

  @prop({_id: false})
  location: Location;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }
}
