import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/main_tab/add_post/add_post_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapController extends LoadingGetController {
  final mapService = MapService();
  final List<Post> posts = [];

  late MainSlidePanelController mainSlidePanelController;
  final PanelController panelController = PanelController();

  late LatLng centerPosition;
  final RxBool showSearch = true.obs;
  final PostAPI _postAPI = PostAPI();

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

  void setMainBar(MainSlidePanelController controller) {
    this.mainSlidePanelController = controller;
  }

  Future<void> startSearch() async {
    mapService.resetMap();
    posts.clear();

    await mapService.setVisibleRegion();

    final LatLng center = await mapService.getCenter();
    final double radius = mapService.GetRadiusOnVisible();

    final Map<String, dynamic> query = {
      "lng": center.longitude.toString(),
      "lat": center.latitude.toString(),
      "radius": radius.toString(),
    };

    final res = await _postAPI.getNearPosts(query);
    if (!res.status) return;
    final items = List<Map<String, dynamic>>.from(res.data);
    final temp = List<Post>.from(items.map((m) => Post.fromMap(m)));
    await panelController.open();

    posts.addAll(temp);

    await Future.forEach(posts, (Post post) async {
      await mapService.addPostMarker(post);
    });

    mapService.addCircle(center, radius);
    showSearch.call(false);
    update();
  }

  Future<void> zoomUp(bool isZoom) async {
    showSearch.call(true);
    await mapService.setZoom(isZoom);
  }

  Future<void> setCenterPosition({LatLng? latLng, double? zoom}) async {
    if (latLng == null) {
      final current = await mapService.getCurrentPosition();
      centerPosition = LatLng(current.latitude, current.longitude);
    } else {
      centerPosition = latLng;
    }

    await mapService.updateCamera(centerPosition, setZoom: zoom);
  }

  void onCmareMove(CameraPosition cameraPosition) {
    if (mapService.visibleRegion == null) return;
    panelController.close();
    showSearch.call(!mapService.visibleRegion!.contains(cameraPosition.target));
  }

  void onCameraIdle() {
    panelController.open();
  }

  Future<void> showAddPost() async {
    final result = await Get.toNamed(AddPostScreen.routeName);

    if (result is Post) {
      posts.add(result);
      await mapService.addPostMarker(result);
      update();
    }
  }

  Future<void> backScreen() async {
    MainTabController.to.backOldIndex();
  }

  /// generate dummy for test

  Future<void> getDummy() async {
    mapService.resetMap();
    posts.clear();
    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final LatLng center = await mapService.getCenter();
      final double radius = mapService.GetRadiusOnVisible();
      final res = await _postAPI.generateDummy(center, radius);
      if (!res.status) return;

      final items = List<Map<String, dynamic>>.from(res.data);

      final temp = List<Post>.from(items.map((m) => Post.fromMap(m)));

      print(temp.length);
      posts.addAll(temp);

      await Future.forEach(posts, (Post post) async {
        await mapService.addPostMarker(post);
      });
      mapService.addCircle(center, radius);
      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}


    // // TODO ---- delete ctr
    // await Get.delete<MapController>();
    // await Get.delete<MainSlidePanelController>();