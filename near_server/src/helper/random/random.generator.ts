import randomCirclePoint from './random_loc';

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

export default {
  intR,
  locationR,
  idR,
  randomObjFromArray,
};
