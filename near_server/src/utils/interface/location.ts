import {modelOptions, prop, Severity} from '@typegoose/typegoose';

@modelOptions({options: {allowMixed: Severity.ALLOW}})
export class Location {
  @prop({type: () => String, enum: ['Point'], required: true})
  type: string;

  @prop({type: () => [Number], required: true})
  coordinates: number[];
}
