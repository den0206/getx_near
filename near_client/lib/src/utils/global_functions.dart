import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import '../model/post.dart';
import '../model/user.dart';
import '../model/utils/response_api.dart';
import '../screen/main_tab/main_tab_controller.dart';
import '../screen/message/message_screen.dart';
import '../service/auth_service.dart';
import '../service/location_service.dart';
import '../service/message_extention.dart';
import '../service/recent_extension.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar({
  required String title,
  required String message,
  Color background = Colors.green,
  SnackPosition position = SnackPosition.BOTTOM,
}) {
  Get.snackbar(
    title,
    message,
    icon: Icon(Icons.person, color: Colors.white),
    snackPosition: position,
    backgroundColor: background,
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

    showSnackBar(
      title: temp.isEmpty ? " 投稿が見つかりませんでした" : "${temp.length} 個の投稿が見つかりました",
      message: temp.isEmpty ? "再度の検索をお願いします。" : "コメントをしてHELPに行こう!",
      background: temp.isEmpty ? Colors.red : ConstsColor.mainOrangeColor,
      position: SnackPosition.BOTTOM,
    );
    return temp;
  } catch (e) {
    throw e;
  }
}

// to Message Screen

Future<void> getToMessScreen({required User user}) async {
  final re = RecentExtension();
  final User currentUser = AuthService.to.currentUser.value!;

  if (user.id == currentUser.id) throw Exception("same One");

  try {
    User withUser;

    if (useMap) {
      withUser = user;
    } else {
      final User sampleUser = User(
        id: "627a335d9d99fe79480b87f8",
        name: "sample",
        email: "ddd@email.com",
        sex: Sex.man,
        fcmToken: "",
        blockedUsers: [],
        isFrozen: false,
        createdAt: DateTime.now(),
      );

      withUser = sampleUser;
    }

    if (currentUser.id == withUser.id) throw Exception("same with user");

    final chatRoomId =
        await re.createPrivateChatRoom(withUser.id, [currentUser, withUser]);

    if (chatRoomId == null) throw Exception("Not Generate ChatRoom Id");

    Get.until((route) => route.isFirst);

    // message
    MainTabController.to.setIndex(3);

    final ext = MessageExtention(chatRoomId, withUser);

    Get.toNamed(MessageScreen.routeName, arguments: ext);
  } catch (e) {
    throw e;
  }
}
