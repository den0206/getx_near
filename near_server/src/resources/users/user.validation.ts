import z, {date, object, string, TypeOf} from 'zod';

export const signUpSchema = {
  body: object({
    name: string({
      message: 'nameが必要です',
    }),
    email: z.email({message: 'emailが必要です'}),
    sex: string({message: '性別が必要です'}),
    createdAt: date({message: '作成時刻が必要です'}),
    password: string({message: 'パスワードが必要です'})
      .min(6, 'at least 6')
      .max(64, 'password too long'),
  }),
};

export type SignUpBody = TypeOf<typeof signUpSchema.body>;
