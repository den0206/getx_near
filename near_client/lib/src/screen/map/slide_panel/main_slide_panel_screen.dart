import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/origin_carousel.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/date_formate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sizer/sizer.dart';

class MainSlideUpPanel extends GetView<MainSlidePanelController> {
  const MainSlideUpPanel(this.mapController, {Key? key}) : super(key: key);

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
          panelSnapping: false,
          isDraggable: !controller.selecting,
          color: ConstsColor.panelColor,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          onPanelSlide: controller.mapController.mapService.changePanelPosition,
          panelBuilder: (sc) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                              Spacer(),
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
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: HelpButton(
                                  post: post,
                                  size: 23.sp,
                                ),
                              ),
                            ],
                          ),
                          Hero(
                            tag: post.id,
                            child: Container(
                              width: 70.sp,
                              height: 70.sp,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                    image: getUserImage(post.user),
                                    fit: BoxFit.contain,
                                  )),
                            ),
                          ),
                          AlertIndicator(
                            intValue: post.emergency,
                            level: post.level,
                            height: 20,
                          ),
                          if (post.distance != null)
                            Text(
                              "約 ${distanceToString(post.distance!)} km",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                        ],
                      ),
                      onTap: () {
                        controller.selectPost(post);
                      },
                    );
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
