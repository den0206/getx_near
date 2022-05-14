import {object, string, TypeOf} from 'zod';

export const signUpSchema = {
  body: object({
    name: string({
      required_error: 'nameが必要です',
    }),
    email: string({required_error: 'emailが必要です'}).email(),
    password: string({required_error: 'パスワードが必要です'})
      .min(6, 'at least 6')
      .max(64, 'password too long'),
  }),
};

export type SignUpBody = TypeOf<typeof signUpSchema.body>;
