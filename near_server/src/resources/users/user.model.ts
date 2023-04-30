import {index, pre, prop, Ref} from '@typegoose/typegoose';
import argon2 from 'argon2';
import AWSClient from '../../utils/aws/aws_client';
import {
  MessageModel,
  PostModel,
  RecentModel,
  UserModel,
} from '../../utils/database/models';
import {Location} from '../../utils/interface/location';
import {CommentModel, ReportModel} from './../../utils/database/models';

@pre<User>('save', async function (next) {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);

    this.password = hashed;
  }
  return next();
})
@pre<User>(
  'deleteOne',
  async function (next) {
    console.log('=== Start USER DELETE');
    console.log('DELETE RELATION', (await this)._id);

    // Messageの削除
    await MessageModel.deleteMany({userId: (await this)._id});

    // Postの削除
    await PostModel.deleteMany({userId: (await this)._id});

    // Recentの削除
    await RecentModel.deleteMany({userId: (await this)._id});
    await RecentModel.deleteMany({withUserId: (await this)._id});

    // Commentの削除
    await CommentModel.deleteMany({userId: (await this)._id});

    // Reportの削除
    await ReportModel.deleteMany({reported: (await this)._id});

    /// アバターの削除
    if ((await this).avatarUrl) {
      const awsClient = new AWSClient();
      console.log('DELETE AVATAR RELATION', (await this)._id);
      await awsClient.deleteImage((await this).avatarUrl);
    }

    // blocksの削除
    await UserModel.updateMany(
      {blocked: {$in: [(await this)._id]}},
      {$pull: {blocked: (await this)._id}}
    );

    next();
  },
  {document: true, query: true}
)
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
  @prop({default: false})
  isFrozen: boolean;
  @prop()
  createdAt: Date;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }
}

export async function hashdPassword(value: string): Promise<string> {
  return await argon2.hash(value);
}
