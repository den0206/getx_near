import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_screen.dart';
import 'package:getx_near/src/screen/widget/common_showcase.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../utils/consts_color.dart';

class MapScreen extends LoadingGetView<MapController> {
  static const routeName = '/MapScreen';
  @override
  MapController get ctr => MapController();

  @override
  void Function()? get onCancel => () {
        controller.cancelLoading();
      };

  @override
  Widget get child {
    return GetBuilder<MapController>(
      builder: (_) {
        return ShowCaseWidget(
          builder: Builder(builder: (context) {
            return Scaffold(
              body: Stack(
                children: [
                  if (useMap) ...[
                    GoogleMap(
                      key: controller.mapService.mapKey,
                      initialCameraPosition: initialCameraPosition,
                      padding: EdgeInsets.only(
                        top: kToolbarHeight,
                        bottom: logoHeifht,
                      ),
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      myLocationEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: false,
                      markers: controller.mapService.markers,
                      circles: controller.mapService.circles,
                      polylines: controller.mapService.polylines,
                      polygons: controller.mapService.polygons,
                      onCameraMove: controller.onCmareMove,
                      onCameraIdle: controller.onCameraIdle,
                      onTap: (argument) {},
                      onMapCreated: (mapCtr) async {
                        await controller.onMapCreate(mapCtr);
                      },
                    )
                  ],
                  _searchButton(),
                  _leftSide(),
                  _rightSide(),
                  MainSlideUpPanel(controller),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _searchButton() {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            Builder(builder: (context) {
              return AppBar(
                leading: IconButton(
                    iconSize: 25.sp,
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      controller.backScreen();
                    }),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              );
            }),
            Obx(
              () => controller.showSearch.value
                  ? Center(
                      child: CommonShowcaseWidget(
                        key: controller.tutorialKey1,
                        description: "画面内の検索を行います",
                        child: FloatingActionButton.extended(
                          heroTag: "btn1",
                          backgroundColor: Colors.white.withOpacity(0.7),
                          label: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black,
                              ),
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.pin_drop_outlined,
                                      size: 16.sp,
                                      color: ConstsColor.mainGreenColor),
                                ),
                                const TextSpan(
                                  text: "このエリアを検索",
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            controller.startSearch();
                          },
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leftSide() {
    return Obx(
      () => Positioned(
        bottom: controller.mapService.buttonSpaceHeight.value,
        left: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.h,
            ),
            CupertinoButton(
              color: Colors.black87,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.add,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await controller.zoomUp(true);
              },
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              color: Colors.black87,
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.remove,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await controller.zoomUp(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightSide() {
    return Obx(
      () => Positioned(
        bottom: controller.mapService.buttonSpaceHeight.value,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Builder(builder: (context) {
                    return NeumorphicIconButton(
                      icon: const Icon(
                        Icons.description,
                        color: Colors.white,
                      ),
                      color: Colors.black,
                      onPressed: () {
                        controller.showTutorial(context);
                      },
                    );
                  }),
                  if (kDebugMode || kProfileMode) ...[
                    SizedBox(
                      height: 1.h,
                    ),
                    NeumorphicIconButton(
                      icon: const Icon(
                        Icons.group,
                        color: Colors.white,
                      ),
                      color: Colors.purple,
                      onPressed: () {
                        controller.startSearch(useDummy: true);
                      },
                    ),
                  ],
                  SizedBox(
                    height: 1.h,
                  ),
                  CommonShowcaseWidget(
                    key: controller.tutorialKey2,
                    description: "あなたの投稿を作成します。",
                    child: NeumorphicIconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      color: ConstsColor.mainGreenColor,
                      onPressed: () {
                        controller.showAddPost();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CommonShowcaseWidget(
                    key: controller.tutorialKey3,
                    description: "現在地に戻ります。",
                    child: FloatingActionButton.extended(
                      heroTag: "btn2",
                      backgroundColor: ConstsColor.mainGreenColor,
                      label: const Text(
                        'Default Position',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        controller.setCenterPosition(zoom: 15);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
