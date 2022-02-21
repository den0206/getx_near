import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/widget/origin_carousel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
          color: Colors.grey[400]!,
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
                  controller: controller.pageController,
                  itemCount: controller.mPosts.length,
                  onChange: controller.postsOnChange,
                  itemBuilder: (context, index) {
                    final post = controller.mPosts[index];
                    return OriginCarouselCell(
                      currentIndex: controller.currentPostIndex,
                      index: index,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(post.content)],
                      ),
                      onTap: () {
                        print(post.toString());
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
