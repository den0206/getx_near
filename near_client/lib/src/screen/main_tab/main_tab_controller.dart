import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/sos/sos_screen.dart';
import '../../service/auth_service.dart';
import '../map/map_screen.dart';
import '../posts/my_posts/my_post_tab_screen.dart';
import '../recent/recent_screen.dart';
import '../users/user_detail/user_detail_screen.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  var currentIndex = 0;
  var oldIndex = 0;

  final List<Widget> fixPages = [
    SOSScreen(),
    MyPostTabScreen(),
    MapScreen(),
    RecentScreen(),
    UserDetailScreen(
      user: AuthService.to.currentUser.value!,
    ),
  ];

  List<Widget> stackPages = [];

  bool get isExistMap {
    return Get.isRegistered<MapController>();
  }

  List<Widget> get currentPages {
    return !isExistMap ? fixPages : stackPages;
  }

  @override
  void onInit() {
    super.onInit();

    stackPages.addAll(fixPages);
  }

  void setIndex(int index) {
    refreshAnotherPages(index);
    if (index == 2) oldIndex = currentIndex;
    currentIndex = index;
    update();
  }

  void backOldIndex() {
    currentIndex = oldIndex;
    refreshAnotherPages(currentIndex);
    update();
  }

  void refreshAnotherPages(int index) {
    final indexes = fixPages.asMap().keys.toList();

    final mapIndex = _getByTypeofIndex<MapScreen>();
    final recentIndex = _getByTypeofIndex<RecentScreen>();

    indexes.removeWhere((element) =>
        element == index || element == mapIndex || element == recentIndex);

    indexes.forEach((i) {
      stackPages.removeAt(i);
      stackPages.insert(i, Container());
    });

    stackPages[index] = fixPages[index];
    print(stackPages);
  }

  int _getByTypeofIndex<T>() {
    return fixPages.indexWhere((element) => element.runtimeType == T);
  }
}
