import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getx_near/main.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/model/utils/visible_region.dart';
import 'package:getx_near/src/service/permission_service.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// LocatinDetail(粒度)
enum LocationDetail { low, medium, high, best }

extension LocationSizeEXT on LocationDetail {
  String get title {
    switch (this) {
      case LocationDetail.low:
        return "低い";
      case LocationDetail.medium:
        return "普通";
      case LocationDetail.high:
        return "高い";
      case LocationDetail.best:
        return "最高";
    }
  }

  LocationAccuracy get accuracy {
    switch (this) {
      case LocationDetail.low:
        return LocationAccuracy.low;
      case LocationDetail.medium:
        return LocationAccuracy.medium;
      case LocationDetail.high:
        return LocationAccuracy.high;
      case LocationDetail.best:
        return LocationAccuracy.best;
    }
  }
}

// storage default
LocationDetail getLocationDetail(String? value) {
  // degault value
  if (value == null) return LocationDetail.high;

  /// String to enum
  final LocationDetail l = LocationDetail.values.firstWhere(
    (c) => c.name == value,
  );

  return l;
}

const kMinDistance = 500;
const kMaxDistance = 5000;
const kDefaultDistance = 2500;

int getNotificationDistance(int? value) {
  // default value
  if (value == null) return kDefaultDistance;
  return value;
}

int getHomeDistance(int? value) {
  // default value
  if (value == null) return kDefaultDistance;
  return value;
}

class LocationService {
  Future<Position> getCurrentPosition() async {
    final permission = PermissionService();
    final locationEnable = await permission.checkLocation();

    try {
      if (!locationEnable) throw Exception("現在地を取得できません");

      final UserAPI _userAPI = UserAPI();
      final LocationDetail localLoc = getLocationDetail(
        await StorageKey.locationSize.loadString(),
      );
      print("精度は${localLoc.title}");

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      final Position current = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (isRealDevice && current.isMocked) throw Exception("不正な位置情報が検出されました。");

      final cood = {"lng": current.longitude, "lat": current.latitude};

      await _userAPI.updateLocation(cood);

      print("Update Location");
      return current;
    } catch (e) {
      rethrow;
    }
  }

  Future<Placemark> positionToAddress(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
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
    from.latitude,
    from.longitude,
    to.latitude,
    to.longitude,
  ).round();
}
