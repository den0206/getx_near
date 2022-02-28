import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getx_near/src/model/utils/visibleRegion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
    }
  }

  Future<Position> getCurrentPosition() async {
    await checkPermission();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
  }

  Future<Placemark> positionToAddress(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks[0];
  }

  LatLngBounds getCameraZoom(LatLng origin, LatLng destination) {
    LatLngBounds bounds;

    if (origin.latitude > destination.latitude &&
        origin.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: origin);
    } else if (origin.longitude > destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(origin.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, origin.longitude),
      );
    } else if (origin.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, origin.longitude),
        northeast: LatLng(origin.latitude, destination.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: origin, northeast: destination);
    }

    return bounds;
  }

  double getRadiusOnVisible(VisibleRegion visibleRegion) {
    //east righ_t
    // west lef_t

    LatLng farEast = visibleRegion.farEast;
    LatLng farWest = visibleRegion.farWest;
    LatLng nearEast = visibleRegion.nearEast;
    LatLng nearWest = visibleRegion.nearWest;

    final distanceWidth = Geolocator.distanceBetween(
      (farWest.latitude + nearWest.latitude) / 2,
      farWest.longitude,
      (farEast.latitude + nearEast.latitude) / 2,
      farEast.longitude,
    );

    final distanceHeight = Geolocator.distanceBetween(
      farEast.latitude,
      (farEast.longitude + farWest.longitude) / 2,
      nearEast.latitude,
      (nearEast.longitude + nearWest.longitude) / 2,
    );

    double radiusInMeters =
        sqrt(pow(distanceWidth, 2) + pow(distanceHeight, 2)) / 7;
    return radiusInMeters;
  }
}

int getDistansePoints(LatLng from, LatLng to) {
  return Geolocator.distanceBetween(
          from.latitude, from.longitude, to.latitude, to.longitude)
      .round();
}
