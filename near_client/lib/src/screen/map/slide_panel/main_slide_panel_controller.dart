import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_screen.dart';

class MainSlidePanelController extends GetxController {
  final MapController mapController;

  MainSlidePanelController(this.mapController);
  final RxnInt currentPostIndex = RxnInt();
  bool selecting = false;

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
    selecting = true;
    final post = mPosts[index];
    await selectPost(post);
  }

  Future<void> selectPost(Post post) async {
    final index = mPosts.indexWhere((p) => p.id == post.id);
    if (currentPostIndex.value == index) showPostDetail(post);

    if (pageController.hasClients) pageController.jumpToPage(index);

    currentPostIndex.call(index);

    if (useMap) {
      await mapController.setCenterPosition(latLng: post.coordinate, zoom: 16);
      mapController.mapService.showInfoService(post.id);
    }

    await Future.delayed(Duration(milliseconds: 500));
    selecting = false;
  }

  Future<void> showPostDetail(Post post) async {
    final _ = Get.toNamed(PostDettailScreen.routeName, arguments: post);

    await mapController.panelController.open();
  }
}
