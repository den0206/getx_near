import randomCirclePoint from './random_loc';
import {UserModel} from '../../utils/database/models';

function intR(max: number): number {
  return Math.floor(Math.random() * max);
}

function locationR(latitude: number, longitude: number, radius: number) {
  const P = {
    latitude,
    longitude,
  };
  const l = randomCirclePoint(P, radius);

  return l;
}

function idR(length: number) {
  var result = '';
  var characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}

function randomObjFromArray(array: any[]) {
  return array[Math.floor(Math.random() * array.length)];
}

function randomSex(): string {
  const n: number = intR(20);

  return n % 2 == 0 ? 'man' : 'woman';
}

function randomImageUrl(sex: string): string {
  const s = sex == 'man' ? 'men' : 'women';
  const n = intR(100);
  return `https://randomuser.me/api/portraits/${s}/${n}.jpg`;
}

function dummyUser(index: number) {
  const sex = randomSex();
  const imageUrl = randomImageUrl(sex);

  const user = new UserModel({
    name: `Sample${index}`,
    email: 'sample@email.com',
    sex: sex,
    avatarUrl: imageUrl,
    password: '12345',
  });

  return user;
}

export default {
  intR,
  locationR,
  idR,
  randomObjFromArray,
  dummyUser,
};
