import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/posts/post_add/add_post_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:getx_near/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../main.dart';
import '../posts/posts_tab/near_posts/near_posts_controller.dart';
import '../widget/common_showcase.dart';

class MapController extends LoadingGetController {
  static MapController get to => Get.find();
  final mapService = MapService();
  late List<Post> posts;

  late MainSlidePanelController mainSlidePanelController;
  final PanelController panelController = PanelController();

  late LatLng currentPosition;

  double currentZoom = 14;
  bool isZooming = false;
  bool isSetDefault = false;

  final RxBool showSearch = true.obs;
  bool get canSearch {
    return currentZoom > 10;
  }

  // tutorilal keys

  final tutorialKey1 = GlobalKey();
  final tutorialKey2 = GlobalKey();
  final tutorialKey3 = GlobalKey();
  final tutorialKey4 = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    initNearPosts();
  }

  Future<void> showTutorial(BuildContext context) async {
    if (!showSearch.value) showSearch.call(true);
    if (panelController.isPanelClosed) await panelController.open();
    CommonShowCase([tutorialKey1, tutorialKey2, tutorialKey3, tutorialKey4])
        .showTutorial(context);
  }

  Future<void> onMapCreate(GoogleMapController controller) async {
    print("init Map");
    try {
      mapService.init(controller);
      await setCenterPosition(zoom: 15);
      await startSearch();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  void initNearPosts() {
    if (!Get.isRegistered<NearPostsController>()) {
      Get.put(NearPostsController());
    }

    // NearPostsController と共有する
    posts = NearPostsController.to.nearPosts;
  }

  void setMainBar(MainSlidePanelController controller) {
    mainSlidePanelController = controller;
  }

  Future<void> startSearch({bool useDummy = false}) async {
    mapService.resetMap();
    posts.clear();
    mainSlidePanelController.currentPostIndex.call(null);
    isLoading.call(true);

    await Future.delayed(const Duration(seconds: 1));
    await setCenterPosition(moveCamera: false);
    try {
      if (!canSearch) throw Exception("範囲が広すぎます");
      if (useMap) await mapService.setVisibleRegion();
      final currentCenter = useMap ? await mapService.getCenter() : shinjukuSta;
      final double radius = useMap ? mapService.getRadiusOnVisible() : 1000;

      final tempPosts = await getTempNearPosts(
          from: useMap ? currentCenter : currentPosition,
          radius: radius,
          useDummy: useDummy);

      posts.addAll(tempPosts);

      if (useMap) {
        await Future.forEach(posts, (Post post) async {
          await mapService.addPostMarker(post, () {
            mainSlidePanelController.selectPost(post);
          });
        });
        mapService.addCircle(currentCenter, radius);
      }
      showSearch.call(false);
      await panelController.open();
      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> zoomUp(bool isZoom) async {
    isZooming = true;
    currentZoom = await mapService.setZoom(isZoom);
  }

  Future<void> setCenterPosition({bool moveCamera = true, double? zoom}) async {
    if (isLoading.value) return;
    isLoading.call(true);
    try {
      final current = await LocationService().getCurrentPosition();

      currentPosition = LatLng(current.latitude, current.longitude);

      if (moveCamera) {
        isSetDefault = true;
        await mapService.updateCamera(currentPosition, setZoom: zoom);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  void onCmareMove(CameraPosition cameraPosition) {
    if (mapService.visibleRegion == null) return;
    if (isZooming || isSetDefault) return;
    showSearch.call(canSearch &&
        !mapService.visibleRegion!.contains(cameraPosition.target));
  }

  void onCameraIdle() async {
    // zoom した後は検索可
    if (isZooming) {
      showSearch.call(canSearch);
      isZooming = false;
    }
    // default に戻ったのちは検索可
    if (isSetDefault) {
      showSearch.call(canSearch);
      isSetDefault = false;
    }
    // await panelController.open();
  }

  Future<void> showAddPost() async {
    final result = await Get.toNamed(AddPostScreen.routeName);

    if (result is Post) {
      posts.insert(0, result);
      await mapService.addPostMarker(result, () {
        mainSlidePanelController.selectPost(result);
      });
      update();
    }
  }

  void backScreen() {
    MainTabController.to.backOldIndex();
  }

  void cancelLoading() {
    backScreen();
  }
}
