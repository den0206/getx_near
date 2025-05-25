import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/screen/widget/origin_carousel.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/date_formate.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widget/common_showcase.dart';

class MainSlideUpPanel extends GetView<MainSlidePanelController> {
  const MainSlideUpPanel(this.mapController, {super.key});

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainSlidePanelController>(
      init: MainSlidePanelController(mapController),
      autoRemove: false,
      builder: (controller) {
        return SlidingUpPanel(
          controller: controller.mapController.panelController,
          minHeight: panelMinHeight,
          maxHeight: panelMaxHeight,
          // backdropEnabled: true,
          defaultPanelState: PanelState.OPEN,
          panelSnapping: false,
          isDraggable: !controller.selecting,
          color: ConstsColor.mainBackColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          onPanelSlide: controller.mapController.mapService.changePanelPosition,
          panelBuilder: (sc) {
            return commonShowcaseWidget(
              key: mapController.tutorialKey4,
              description: "近隣の投稿が表示されます。",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  OriginCarousel(
                    pageController: controller.pageController,
                    itemCount: controller.mPosts.length,
                    onChange: controller.postsOnChange,
                    itemBuilder: (context, index) {
                      final post = controller.mPosts[index];
                      return OriginCarouselCell(
                        currentIndex: controller.currentPostIndex,
                        index: index,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  post.user.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: HelpButton(post: post, size: 23.sp),
                                ),
                              ],
                            ),
                            UserAvatarButton(user: post.user, size: 70.sp),
                            AlertIndicator(
                              intValue: post.emergency,
                              level: post.level,
                              height: 20,
                            ),
                            if (post.distance != null)
                              Text(
                                "約 ${distanceToString(post.distance!)} km",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        onTap: () {
                          controller.selectPost(post);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
