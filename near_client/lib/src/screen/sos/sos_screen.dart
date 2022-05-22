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
              style: commonNeumorphic,
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
                          NeumorphicText(
                            "SOS",
                            style:
                                commonNeumorphic.copyWith(color: Colors.yellow),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 25.sp,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Image.asset(
                            "assets/images/police.png",
                            width: 120.sp,
                            height: 120.sp,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          NeumorphicText(
                            "Call The Police!",
                            style: commonNeumorphic.copyWith(
                              color: controller.isPlaying.value
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
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
