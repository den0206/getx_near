import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MainSlideUpPanel extends GetView<MapController> {
  const MainSlideUpPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      minHeight: panelMinHeight,
      maxHeight: panelMaxHeight,
      color: Colors.grey[400]!,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 5),
      header: Center(
        child: Container(
          width: 30,
          height: 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
        ),
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      panelBuilder: (sc) {
        return Container();
      },
      onPanelSlide: controller.mapService.changePanelPosition,
    );
  }
}
