import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getx_near/src/model/visibleRegion.dart';
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
