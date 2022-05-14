import {prop, pre} from '@typegoose/typegoose';
import argon2 from 'argon2';

@pre<User>('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);

    this.password = hashed;
  }
  return next();
})
export class User {
  @prop({required: true, maxlength: 20})
  name: string;
  @prop({required: true, unique: true})
  email: string;
  @prop()
  avatarUrl: string;
  @prop({required: true})
  password: string;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }
}
