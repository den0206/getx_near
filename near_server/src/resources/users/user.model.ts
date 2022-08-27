import {CommentModel, ReportModel} from './../../utils/database/models';
import {prop, pre, index, Ref} from '@typegoose/typegoose';
import argon2 from 'argon2';
import AWSClient from '../../utils/aws/aws_client';
import {
  MessageModel,
  PostModel,
  RecentModel,
} from '../../utils/database/models';
import {Location} from '../../utils/interface/location';

@pre<User>('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);

    this.password = hashed;
  }
  return next();
})
@pre<User>('remove', async function (next) {
  console.log('=== Start USER DELETE');
  console.log('DELETE RELATION', this._id);

  // Messageの削除
  await MessageModel.deleteMany({userId: this._id});

  // Postの削除
  await PostModel.deleteMany({userId: this._id});

  // Recentの削除
  await RecentModel.deleteMany({userId: this._id});
  await RecentModel.deleteMany({withUserId: this._id});

  // Commentの削除
  await CommentModel.deleteMany({userId: this._id});

  // Reportの削除
  await ReportModel.deleteMany({reported: this._id});

  /// アバターの削除
  if (this.avatarUrl) {
    const awsClient = new AWSClient();
    console.log('DELETE AVATAR RELATION', this._id);
    await awsClient.deleteImage(this.avatarUrl);
  }

  next();
})
@index({location: '2dsphere'})
export class User {
  @prop({required: true, maxlength: 20})
  name: string;
  @prop({required: true, unique: true})
  email: string;
  @prop({required: true, enum: ['man', 'woman']})
  sex: string;
  @prop()
  avatarUrl: string;
  @prop({required: true})
  password: string;
  @prop({default: [], ref: () => User})
  blocked: Ref<User>[];
  @prop()
  fcmToken: string;
  @prop({_id: false})
  location: Location;
  @prop()
  createdAt: Date;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }
}

export async function hashdPassword(value: string): Promise<string> {
  return await argon2.hash(value);
}
