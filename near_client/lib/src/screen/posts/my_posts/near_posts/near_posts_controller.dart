import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../widget/loading_widget.dart';

class NearPostsController extends LoadingGetController {
  static NearPostsController get to => Get.find();
  final List<Post> nearPosts = [];

  final LocationService _locationService = LocationService();

  double radius = 830;

  @override
  void onInit() async {
    super.onInit();

    await _getNearPosts();
  }

  Future<void> _getNearPosts() async {
    try {
      final Position position = await _locationService.getCurrentPosition();
      print(radius);

      final tempPosts = await getTempNearPosts(
          from: LatLng(position.latitude, position.longitude), radius: radius);

      nearPosts.addAll(tempPosts);
      update();
    } catch (e) {
      showError(e.toString());
    }
  }
}
