import {
  getModelForClass,
  prop,
  pre,
  DocumentType,
  modelOptions,
  Severity,
} from '@typegoose/typegoose';

@modelOptions({options: {allowMixed: Severity.ALLOW}})
export class Location {
  @prop({enum: ['Point'], required: true})
  type: string;

  @prop({required: true})
  coordinates: number[];
}
