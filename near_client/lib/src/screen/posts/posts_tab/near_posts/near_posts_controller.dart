import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearPostsController extends GetxController {
  static NearPostsController get to => Get.find();
  final List<Post> nearPosts = [];
  final LocationService _locationService = LocationService();

  double radius = 830;

  bool get isCompEmpty {
    return nearPosts.isEmpty && !topLoading.value;
  }

  Future<void> getNearPosts() async {
    topLoading.call(true);
    try {
      nearPosts.clear();
      update();

      final Position position = await _locationService.getCurrentPosition();

      final tempPosts = await getTempNearPosts(
        from: LatLng(position.latitude, position.longitude),
        radius: radius,
      );

      nearPosts.addAll(tempPosts);
      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      topLoading.call(false);
    }
  }

  Future<void> tapCell(Post post) async {
    try {
      if (Get.isRegistered<MainSlidePanelController>()) {
        MainSlidePanelController.to.currentPostIndex.value = null;
        await MainSlidePanelController.to.selectPost(post);

        topLoading.call(true);
        await Future.delayed(const Duration(seconds: 1));
      }

      // MapView への遷移
      MainTabController.to.setIndex(2);
    } catch (e) {
      showError(e.toString());
    } finally {
      topLoading.call(false);
    }
  }
}
