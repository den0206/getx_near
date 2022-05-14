import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/utils/response_api.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/posts/post_add/add_post_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapController extends LoadingGetController {
  final mapService = MapService();
  final List<Post> posts = [];

  late MainSlidePanelController mainSlidePanelController;
  final PanelController panelController = PanelController();

  late LatLng currentPosition;
  final RxBool showSearch = true.obs;
  final PostAPI _postAPI = PostAPI();

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

  void setMainBar(MainSlidePanelController controller) {
    this.mainSlidePanelController = controller;
  }

  Future<void> startSearch({bool useDummy = false}) async {
    mapService.resetMap();
    posts.clear();
    mainSlidePanelController.currentPostIndex.call(null);
    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));
    await setCenterPosition(moveCamera: false);
    try {
      if (useMap) await mapService.setVisibleRegion();
      final currentCenter = useMap ? await mapService.getCenter() : shinjukuSta;
      final double radius = useMap ? mapService.GetRadiusOnVisible() : 1000;

      ResponseAPI res;

      if (!useDummy) {
        final Map<String, dynamic> query = {
          "lng": currentCenter.longitude.toString(),
          "lat": currentCenter.latitude.toString(),
          "radius": radius.toString(),
        };

        res = await _postAPI.getNearPosts(query);
      } else {
        res = await _postAPI.generateDummyAll(currentCenter, radius);
      }

      if (!res.status) return;
      final items = List<Map<String, dynamic>>.from(res.data);
      final temp = List<Post>.from(items.map((m) => Post.fromMap(m)));

      /// distanceの取得
      temp
          .map((p) => {
                p.distance = getDistansePoints(
                    !useMap ? currentCenter : currentPosition, p.coordinate)
              })
          .toList();

      posts.addAll(temp);

      if (useMap) {
        await Future.forEach(posts, (Post post) async {
          await mapService.addPostMarker(post, () {
            mainSlidePanelController.selectPost(post);
          });
        });
        mapService.addCircle(currentCenter, radius);
      }

      await panelController.open();
      update();
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> zoomUp(bool isZoom) async {
    showSearch.call(true);
    await mapService.setZoom(isZoom);
  }

  Future<void> setCenterPosition({bool moveCamera = true, double? zoom}) async {
    final current = await mapService.getCurrentPosition();
    currentPosition = LatLng(current.latitude, current.longitude);

    if (moveCamera)
      await mapService.updateCamera(currentPosition, setZoom: zoom);
  }

  void onCmareMove(CameraPosition cameraPosition) {
    if (mapService.visibleRegion == null) return;

    showSearch.call(!mapService.visibleRegion!.contains(cameraPosition.target));
  }

  void onCameraIdle() async {
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

  Future<void> backScreen() async {
    MainTabController.to.backOldIndex();
  }
}
