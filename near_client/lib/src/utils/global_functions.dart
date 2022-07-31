import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/post.dart';
import '../model/utils/response_api.dart';
import '../service/location_service.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar({required String title}) {
  Get.snackbar(
    title,
    "Please Login",
    icon: Icon(Icons.person, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: ConstsColor.mainGreenColor,
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

Future<List<Post>> getTempNearPosts(
    {required LatLng from,
    required double radius,
    bool useDummy = false}) async {
  try {
    final PostAPI _postAPI = PostAPI();
    ResponseAPI res;

    if (!useDummy) {
      final Map<String, dynamic> query = {
        "lng": from.longitude.toString(),
        "lat": from.latitude.toString(),
        "radius": radius.toString(),
      };

      res = await _postAPI.getNearPosts(query);
    } else {
      res = await _postAPI.generateDummyAll(from, radius);
    }

    final items = List<Map<String, dynamic>>.from(res.data);
    final temp = List<Post>.from(items.map((m) => Post.fromMap(m)));

    /// distanceの取得
    temp
        .map((p) => {p.distance = getDistansePoints(from, p.coordinate)})
        .toList();
    return temp;
  } catch (e) {
    throw e;
  }
}
