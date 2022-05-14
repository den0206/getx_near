interface Coordinate {
  latitude: number;
  longitude: number;
}

const EARTH_RADIUS = 6371000; // meters

const DEG_TO_RAD = Math.PI / 180.0;
const THREE_PI = Math.PI * 3;
const TWO_PI = Math.PI * 2;

const toRadians = (deg: number) => deg * DEG_TO_RAD;
const toDegrees = (rad: number) => rad / DEG_TO_RAD;

function randomCircumferencePoint(centerPoint: Coordinate, radius: number) {
  const sinLat = Math.sin(toRadians(centerPoint.latitude));
  const cosLat = Math.cos(toRadians(centerPoint.latitude));

  const bearing = Math.random() * TWO_PI;
  const sinBearing = Math.sin(bearing);
  const cosBearing = Math.cos(bearing);

  const theta = radius / EARTH_RADIUS;
  const sinTheta = Math.sin(theta);
  const cosTheta = Math.cos(theta);
  let rLatitude, rLongitude;
  rLatitude = Math.asin(sinLat * cosTheta + cosLat * sinTheta * cosBearing);
  rLongitude =
    toRadians(centerPoint.longitude) +
    Math.atan2(
      sinBearing * sinTheta * cosLat,
      cosTheta - sinLat * Math.sin(rLatitude)
    );

  rLongitude = ((rLongitude + THREE_PI) % TWO_PI) - Math.PI;

  return {
    latitude: toDegrees(rLatitude),
    longitude: toDegrees(rLongitude),
  };
}

export default function randomCirclePoint(
  centerPoint: Coordinate,
  radius: number
) {
  return randomCircumferencePoint(
    centerPoint,
    Math.sqrt(Math.random()) * radius
  );
}
