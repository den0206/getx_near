import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_screen.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';

import '../../../../main.dart';

class MainSlidePanelController extends GetxController {
  static MainSlidePanelController get to => Get.find();
  final MapController mapController;

  MainSlidePanelController(this.mapController);
  final RxnInt currentPostIndex = RxnInt();
  bool selecting = false;

  MapService get mapService {
    return mapController.mapService;
  }

  List<Post> get mPosts {
    return mapController.posts;
  }

  final pageController = PageController(initialPage: 0, viewportFraction: 0.6);

  @override
  void onInit() {
    super.onInit();
    mapController.setMainBar(this);
  }

  Future<void> postsOnChange(int index) async {
    final post = mPosts[index];
    await selectPost(post);
  }

  Future<void> selectPost(Post post) async {
    final index = mPosts.indexWhere((p) => p.id == post.id);
    if (currentPostIndex.value == index) await showPostDetail(post);

    if (pageController.hasClients) pageController.jumpToPage(index);

    currentPostIndex.call(index);

    if (useMap) {
      mapService.addCenterToPostPolyLine(
        center: mapController.currentPosition,
        post: post,
        color: post.level.mainColor,
      );

      mapService.showInfoService(post.id);
      mapController.update();

      await mapService.fitTwoPointsZoom(
          from: mapController.currentPosition, to: post.coordinate);
    }
  }

  Future<void> showPostDetail(Post post) async {
    final _ = await Get.toNamed(PostDettailScreen.routeName, arguments: post);

    if (mapController.panelController.isPanelClosed)
      await mapController.panelController.open();
  }
}
