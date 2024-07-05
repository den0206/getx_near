import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/utils/custom_exception.dart';
import 'package:getx_near/src/screen/widget/common_showcase.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
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

  // tutorilal keys

  final tutorialKey1 = GlobalKey();
  final tutorialKey2 = GlobalKey();
  final tutorialKey3 = GlobalKey();

  void showTutorial(BuildContext context) {
    CommonShowCase([tutorialKey1, tutorialKey2, tutorialKey3])
        .showTutorial(context);
  }

  void streamText(String? value) {
    canSend.call(!(value == null || value == ""));
  }

  Future<void> sendPost() async {
    isLoading.call(true);

    final maxDistance = getNotificationDistance(
        await StorageKey.notificationDistance.loadInt());
    print("通知距離: $maxDistance");

    try {
      final Position current = await _locationService.getCurrentPosition();

      // check Protect Home
      final isProtect = await _checkProtecthome(postPosition: current);
      if (!isProtect) throw Exception("居住地からの距離が近いため送信できません.");

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

      if (Get.isRegistered<MyPostsController>()) {
        MyPostsController.to.insertPost(post);
      }

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

      // 自身のFCMを除く
      final myToken = AuthService.to.currentUser.value!.fcmToken;
      tokens.remove(myToken);

      // notification　を送る
      if (tokens.isNotEmpty) {
        await NotificationService.to.pushPostNotification(
          tokens: tokens,
          type: NotificationType.post,
        );
      }
    } on FailNotificationException {
      print("通知に失敗しました");
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<bool> _checkProtecthome({required Position postPosition}) async {
    final currentUser = AuthService.to.currentUser.value!;
    // 未登録の場合,飛ばす
    if (!currentUser.hasHome) return true;

    final int homeDistance =
        getHomeDistance(await StorageKey.homeDistance.loadInt());

    // 2点間の距離の計算(m)
    int distanceBetween = Geolocator.distanceBetween(
      currentUser.home!.latitude,
      currentUser.home!.longitude,
      postPosition.latitude,
      postPosition.longitude,
    ).round();

    print("離れている距離は$distanceBetween m");
    if (homeDistance > distanceBetween) {
      return false;
    } else {
      return true;
    }
  }
}
