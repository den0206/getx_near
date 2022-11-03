import {DocumentType} from '@typegoose/typegoose';
import {IModelOptions} from '@typegoose/typegoose/lib/types';

export function commoneSchemaOption<T>({
  useTimestamp = false,
}: {
  useTimestamp?: boolean;
}): IModelOptions {
  return {
    schemaOptions: {
      toJSON: {
        transform: (doc: DocumentType<T>, ret) => {
          delete ret.__v;
          ret.id = ret._id;
          delete ret._id;
        },
      },
      timestamps: useTimestamp || false,
    },
  };
}
