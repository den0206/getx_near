import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';

class AddPostController extends LoadingGetController {
  final TextEditingController tX = TextEditingController();
  final RxBool canSend = false.obs;

  final PostAPI _postAPI = PostAPI();
  final LocationService _locationService = LocationService();

  final RxDouble emergencyValue = 50.0.obs;
  ExpireTime expireTime = ExpireTime.one_hour;

  RxInt get emergency {
    return emergencyValue.round().obs;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void streamText(String? value) {
    canSend.call(!(value == null || value == ""));
  }

  void chanheExpire(ExpireTime? expire) {
    if (expire == null) return;
    expireTime = expire;
  }

  Future<void> sendPost() async {
    isLoading.call(true);

    try {
      final Position current = await _locationService.getCurrentPosition();
      final expire = expireTime.time;
      final Map<String, dynamic> body = {
        "content": tX.text,
        "longitude": current.longitude,
        "latitude": current.latitude,
        "emergency": emergency.value,
        "expireAt": expire.toIso8601String(),
      };

      final res = await _postAPI.createPost(body);
      if (!res.status) return;

      // notificaton を送るユーザーを集める
      final Post post = Post.fromMap(res.data["newPost"]);
      MyPostsController.to.insertPost(post);

      Get.back(result: post);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
