const randomLocation = require('random-location');

function intR(max) {
  return Math.floor(Math.random() * max);
}

function locationR(latitude, longitude, radius) {
  const P = {
    latitude: latitude,
    longitude: longitude,
  };

  const R = parseInt(radius);

  return randomLocation.randomCirclePoint(P, R);
}

function idR(length) {
  var result = '';
  var characters =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for (var i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }
  return result;
}

module.exports = {
  intR,
  locationR,
  idR,
};
