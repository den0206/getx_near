import 'package:getx_near/src/api/test_post_api.dart';
import 'package:getx_near/src/model/test_post.dart';
import 'package:getx_near/src/screen/main_tab/add_post/add_post_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class MapController extends LoadingGetController {
  final mapService = MapService();
  final List<TestPost> posts = [];

  late LatLng centerPosition;
  final RxBool showSearch = true.obs;
  final TestPostAPI _testPostAPI = TestPostAPI();

  Future<void> onMapCreate(GoogleMapController controller) async {
    isLoading.call(true);
    try {
      mapService.init(controller);
      await setCenterPosition();
      await Future.delayed(Duration(seconds: 1));
      await startSearch();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> startSearch() async {
    mapService.resetMap();
    posts.clear();

    await mapService.setVisibleRegion();

    final LatLng center = await mapService.getCenter();
    final double radius = mapService.GetRadiusOnVisible();
    print(center);
    final Map<String, dynamic> query = {
      "lng": center.longitude.toString(),
      "lat": center.latitude.toString(),
      "radius": radius.toString(),
    };

    final res = await _testPostAPI.getNearPosts(query);
    if (!res.status) return;
    final items = List<Map<String, dynamic>>.from(res.data);
    final temp = List<TestPost>.from(items.map((m) => TestPost.fromMap(m)));
    print(temp.length);
    posts.addAll(temp);

    posts.forEach((element) {
      mapService.addMarker(element);
    });

    mapService.addCircle(center, radius);
    showSearch.call(false);
    update();
  }

  Future<void> zoomUp(bool isZoom) async {
    showSearch.call(true);
    await mapService.setZoom(isZoom);
  }

  Future<void> setCenterPosition({LatLng? latLng}) async {
    if (latLng == null) {
      final current = await mapService.getCurrentPosition();
      centerPosition = LatLng(current.latitude, current.longitude);
    } else {
      centerPosition = latLng;
    }

    await mapService.updateCamera(centerPosition);
  }

  void onCmareMove(CameraPosition cameraPosition) {
    if (mapService.visibleRegion == null) return;

    showSearch.call(!mapService.visibleRegion!.contains(cameraPosition.target));
  }

  void onCameraIdle() {
    print("Stop Move");
  }

  Future<void> showAddPost() async {
    final result = await Get.toNamed(AddPostScreen.routeName);

    if (result is TestPost) {
      print("ADD");
      posts.add(result);
      mapService.addMarker(result);
      update();
    }
  }

  Future<void> backScreen() async {
    // TODO ---- delete ctr
    await Get.delete<MapController>();
    MainTabController.to.backOldIndex();
  }
}
