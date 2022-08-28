import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/notification_service.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';

import '../../main_tab/main_tab_controller.dart';
import '../posts_tab/my_posts/my_posts_controller.dart';

class AddPostController extends LoadingGetController {
  final TextEditingController tX = TextEditingController();
  final RxBool canSend = false.obs;

  final PostAPI _postAPI = PostAPI();
  final LocationService _locationService = LocationService();

  final RxDouble emergencyValue = 50.0.obs;
  final Rx<ExpireTime> expireTime = ExpireTime.one_hour.obs;

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

    final maxDistance = getNotificationDistance(
        await StorageKey.notificationDistance.loadInt());
    print("通知距離: ${maxDistance}");

    try {
      final Position current = await _locationService.getCurrentPosition();

      final expire = expireTime.value.time;
      final AlertLevel alert = getAlert(emergencyValue.value);
      final Map<String, dynamic> body = {
        "content": tX.text,
        "longitude": current.longitude,
        "latitude": current.latitude,
        "maxDistance": maxDistance,
        "emergency": emergency.value,
        "expireAt": expire.toUtc().toIso8601String(),
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

      if (MainTabController.to.currentIndex !=
          MainTabController.to.postsIndex) {
        MainTabController.to.setIndex(MainTabController.to.postsIndex);
      }

      canSend.call(false);
      tX.clear();

      Get.back(result: post);

      showSnackBar(
        title: "通知が送られました",
        message: "周辺の${tokens.length} 人に通知が送信されました。",
        background: alert.mainColor,
        position: SnackPosition.TOP,
      );
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
