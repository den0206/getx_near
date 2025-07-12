import {IModelOptions} from '@typegoose/typegoose/lib/types';

export function commoneSchemaOption({
  useTimestamp = false,
}: {
  useTimestamp?: boolean;
}): IModelOptions {
  return {
    schemaOptions: {
      toJSON: {
        transform: function (_, ret: any) {
          // replace _id to id
          ret.id = ret._id;
          // remove _id & __v
          delete ret._id;
          delete ret.__v;
        },
        versionKey: false,
      },
      // _vをつけない様にする
      versionKey: false,
      timestamps: useTimestamp || false,
    },
  };
}
