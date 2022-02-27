import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar({required String title}) {
  Get.snackbar(
    title,
    "Please Login",
    icon: Icon(Icons.person, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    borderRadius: 20,
    margin: EdgeInsets.all(15),
    colorText: Colors.white,
    duration: Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.down,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}

LatLng getLatLngFromMongoose(Map<String, dynamic> map) {
  final cood = List<double>.from(map["location"]["coordinates"]);

  /// CAUTION mongoose lat: [1], lng[0]
  return LatLng(cood[1], cood[0]);
}

Map<String, dynamic> parseToLatlng(LatLng lat) {
  return {
    "coordinates": [lat.longitude, lat.latitude]
  };
}
