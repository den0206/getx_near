import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/sos/sos_screen.dart';
import 'package:getx_near/src/screen/tutorial/tutorial_screen.dart';
import 'package:getx_near/src/service/storage_service.dart';

import '../../service/auth_service.dart';
import '../map/map_screen.dart';
import '../posts/posts_tab/my_post_tab_screen.dart';
import '../recent/recent_screen.dart';
import '../users/user_detail/user_detail_screen.dart';

class MainTabController extends GetxController {
  static MainTabController get to => Get.find();
  var currentIndex = 0;
  var oldIndex = 0;

  // 過去に閲覧済みかの変数
  bool readTutolial = false;
  // viewが表示されているかの変数
  bool _isTutorial = false;

  late final int postsIndex;
  late final int mapIndex;
  late final int recentIndex;

  final List<Widget> fixPages = [
    const SOSScreen(),
    const MyPostTabScreen(),
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
    _setSpecificIndex();
  }

  Future<void> showTutorial(BuildContext context) async {
    readTutolial = await StorageKey.loginTutolial.loadBool() ?? false;

    if (!_isTutorial && !readTutolial) {
      _isTutorial = true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorialPage(),
          fullscreenDialog: true,
        ),
      ).then((value) => _isTutorial = false);
    }
  }

  void _setSpecificIndex() {
    postsIndex = _getByTypeofIndex<MyPostTabScreen>();
    mapIndex = _getByTypeofIndex<MapScreen>();
    recentIndex = _getByTypeofIndex<RecentScreen>();
  }

  void setIndex(int index) {
    refreshAnotherPages(index);
    if (index == mapIndex) oldIndex = currentIndex;
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

    indexes.removeWhere((element) =>
        element == index || element == mapIndex || element == recentIndex);

    for (var i in indexes) {
      stackPages.removeAt(i);
      stackPages.insert(i, Container());
    }

    stackPages[index] = fixPages[index];
    print(stackPages);
  }

  int _getByTypeofIndex<T>() {
    return fixPages.indexWhere((element) => element.runtimeType == T);
  }
}
