import {object, string, TypeOf} from 'zod';

export const signUpSchema = {
  body: object({
    name: string({
      required_error: 'nameが必要です',
    }),
    email: string({required_error: 'emailが必要です'}).email(),
    sex: string({required_error: '性別が必要です'}),
    createdAt: string({required_error: '作成時刻が必要です'}),
    password: string({required_error: 'パスワードが必要です'})
      .min(6, 'at least 6')
      .max(64, 'password too long'),
  }),
};

export type SignUpBody = TypeOf<typeof signUpSchema.body>;
