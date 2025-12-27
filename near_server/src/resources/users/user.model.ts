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

@pre<User>('save', async function () {
  if (this.isModified('password') || this.isNew) {
    const hashed = await argon2.hash(this.password);

    this.password = hashed;
  }
})
@pre<User>(
  'deleteOne',
  async function () {
    console.log('=== Start USER DELETE');
    console.log('DELETE RELATION', (await this)._id);

    const userId = (await this)._id;

    // Messageの削除
    await MessageModel.deleteMany({userId: userId} as any);

    // Postの削除
    await PostModel.deleteMany({userId: userId} as any);

    // Recentの削除
    await RecentModel.deleteMany({userId: userId} as any);
    await RecentModel.deleteMany({withUserId: userId} as any);

    // Commentの削除
    await CommentModel.deleteMany({userId: userId} as any);

    // Reportの削除
    await ReportModel.deleteMany({reported: userId} as any);

    /// アバターの削除
    if ((await this).avatarUrl) {
      const awsClient = new AWSClient();
      console.log('DELETE AVATAR RELATION', userId);
      await awsClient.deleteImage((await this).avatarUrl);
    }

    // blocksの削除
    await UserModel.updateMany(
      {blocked: {$in: [userId]}},
      {$pull: {blocked: userId}}
    );
  },
  {document: true, query: true}
)
@index({location: '2dsphere'})
export class User {
  @prop({type: () => String, required: true, maxlength: 20})
  name: string;
  @prop({type: () => String, required: true, unique: true})
  email: string;
  @prop({type: () => String, required: true, enum: ['man', 'woman']})
  sex: string;
  @prop({type: () => String})
  avatarUrl: string;
  @prop({type: () => String, required: true})
  password: string;
  @prop({default: [], ref: () => User})
  blocked: Ref<User>[];
  @prop({type: () => String})
  fcmToken: string;
  @prop({type: () => Location, _id: false})
  location: Location;
  @prop({type: () => Boolean, default: false})
  isFrozen: boolean;
  @prop({type: () => Date})
  createdAt: Date;

  async comparePasswrd(password: string): Promise<boolean> {
    return await argon2.verify(this.password, password);
  }
}

export async function hashdPassword(value: string): Promise<string> {
  return await argon2.hash(value);
}
