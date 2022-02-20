import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/test_post_api.dart';
import 'package:getx_near/src/model/test_post.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';

class AddPostController extends LoadingGetController {
  final TextEditingController tX = TextEditingController();
  final RxBool canSend = false.obs;

  final TestPostAPI _testPostAPI = TestPostAPI();
  final LocationService _locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
  }

  void streamText(String? value) {
    canSend.call(!(value == null || value == ""));
  }

  Future<void> sendPost() async {
    isLoading.call(true);

    try {
      final Position current = await _locationService.getCurrentPosition();
      final Map<String, dynamic> body = {
        // "title": "title",
        "content": tX.text,
        "longitude": current.longitude,
        "latitude": current.latitude,
      };

      final res = await _testPostAPI.createPost(body);
      if (!res.status) return;

      final TestPost post = TestPost.fromMap(res.data);
      Get.back(result: post);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
