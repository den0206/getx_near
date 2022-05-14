import {IModelOptions} from '@typegoose/typegoose/lib/types';
import {DocumentType, modelOptions} from '@typegoose/typegoose';

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
