import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/sos/sos_controller.dart';
import 'package:getx_near/src/screen/widget/blinking_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/longpress_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SOSController>(
      init: SOSController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: LongNeumorphicButton(
              onPressed: () => controller.play(),
              onEnded: () => controller.pause(),
              minDistance: -5,
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 10,
                lightSource: LightSource.topLeft,
                color: ConstsColor.panelColor,
              ),
              child: Container(
                width: 70.w,
                height: 66.h,
                child: Center(
                  child: Obx(
                    () => BlinkingWidet(
                      use: !controller.isPlaying.value,
                      duration: Duration(seconds: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "SOS",
                          //   style:
                          //       TextStyle(color: Colors.red, fontSize: 30.sp),
                          // ),
                          Icon(
                            Icons.local_police,
                            color: Colors.yellow,
                            size: 70,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            // "HELP",
                            "Call The Police!",
                            style: TextStyle(
                                color: controller.isPlaying.value
                                    ? Colors.red
                                    : Colors.blue,
                                fontSize: 20.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
