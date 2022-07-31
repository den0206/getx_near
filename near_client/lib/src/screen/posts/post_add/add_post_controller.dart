import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/notification_service.dart';

class AddPostController extends LoadingGetController {
  final TextEditingController tX = TextEditingController();
  final RxBool canSend = false.obs;

  final PostAPI _postAPI = PostAPI();
  final LocationService _locationService = LocationService();

  final RxDouble emergencyValue = 50.0.obs;
  final Rx<ExpireTime> expireTime = ExpireTime.one_hour.obs;
  // ExpireTime expireTime = ExpireTime.one_hour;

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

  Future<void> sendPost() async {
    isLoading.call(true);

    try {
      final Position current = await _locationService.getCurrentPosition();

      final expire = expireTime.value.time;
      final Map<String, dynamic> body = {
        "content": tX.text,
        "longitude": current.longitude,
        "latitude": current.latitude,
        "emergency": emergency.value,
        "expireAt": expire.toIso8601String(),
      };

      final res = await _postAPI.createPost(body);
      if (!res.status) return;

      final Post post = Post.fromMap(res.data["newPost"]);

      // notificaton を送るユーザーを集める
      final tokens = List<String>.from(res.data["tokens"]);

      // 自身のFCMを除く
      final myToken = AuthService.to.currentUser.value!.fcmToken;
      tokens.remove(myToken);

      // notification　を送る
      if (tokens.isNotEmpty)
        await NotificationService.to.pushPostNotification(
            tokens: tokens, type: NotificationType.post, content: "Help!");

      if (Get.isRegistered<MyPostsController>())
        MyPostsController.to.insertPost(post);

      Get.back(result: post);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
