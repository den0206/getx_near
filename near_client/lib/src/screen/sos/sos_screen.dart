import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/sos/sos_controller.dart';
import 'package:getx_near/src/screen/widget/blinking_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/longpress_button.dart';
import 'package:sizer/sizer.dart';

import '../../model/alert_voice.dart';
import '../../utils/neumorphic_style.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SOSController>(
      init: SOSController(),
      global: false,
      dispose: (state) {
        // release Controller
        state.controller?.releaseController(state);
      },
      builder: (controller) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: AlertVoice.values.map((alert) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: NeumorphicRadio(
                      style: commonRatioStyle(),
                      padding: const EdgeInsets.all(20),
                      value: alert,
                      groupValue: controller.currentAlert,
                      onChanged: (AlertVoice? value) {
                        if (value == null) return;
                        controller.selectAlert(value);
                      },
                      child: Icon(alert.iconData, size: 25.sp),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 5.h),
              LongNeumorphicButton(
                onPressed: () => controller.play(),
                onEnded: () => controller.pause(),
                minDistance: -5,
                style: commonNeumorphic(depth: 1.6),
                child: SizedBox(
                  width: 70.w,
                  height: 55.h,
                  child: Center(
                    child: Obx(
                      () => BlinkingWidet(
                        use: !controller.isPlaying.value,
                        duration: const Duration(seconds: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NeumorphicText(
                              "SOS",
                              style: commonNeumorphic(color: Colors.yellow),
                              textStyle: NeumorphicTextStyle(fontSize: 25.sp),
                            ),
                            SizedBox(height: 10.h),
                            Image.asset(
                              controller.currentAlert.imagePath,
                              width: 120.sp,
                              height: 120.sp,
                            ),
                            SizedBox(height: 5.h),
                            NeumorphicText(
                              controller.currentAlert.description,
                              style: commonNeumorphic(
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
            ],
          ),
        );
      },
    );
  }
}
