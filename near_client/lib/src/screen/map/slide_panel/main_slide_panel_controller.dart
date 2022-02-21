import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/test_post.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';

class MainSlidePanelController extends GetxController {
  final MapController mapController;

  MainSlidePanelController(this.mapController);
  final RxnInt currentPostIndex = RxnInt();

  List<TestPost> get mPosts {
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

  Future<void> selectPost(TestPost post) async {
    final index = mPosts.indexWhere((p) => p.id == post.id);
    currentPostIndex.call(index);
    await mapController.setCenterPosition(latLng: post.coordinate, zoom: 16);
    mapController.mapService.showInfoService(post.id);
  }
}
