import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class LoadingGetController extends GetxController {
  final RxBool isLoading = false.obs;

  String? nextCursor;
  bool reachLast = false;
  bool cellLoading = false;

  void showCellLoading(bool show) {
    cellLoading = show;
    update();
  }
}

abstract class LoadingGetView<T extends LoadingGetController>
    extends GetView<T> {
  T get ctr;
  final bool isFenix = false;
  final bool isForceDelete = false;
  final void Function()? onCancel = null;

  // use backgroundTap
  final bool enableTap = true;
  Widget get child;

  void backgroundTap(BuildContext context) {
    dismisskeyBord(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<T>()) {
      print(" fenix is ${isFenix}");
      Get.lazyPut(() => ctr, fenix: isFenix);
    }

    return VisibilityDetector(
      key: Key("${ctr}"),
      onVisibilityChanged: isForceDelete
          ? (visibilityInfo) {
              var visiblePercentage = visibilityInfo.visibleFraction * 100;
              if (visiblePercentage == 0 && Get.isRegistered<T>())
                Get.delete<T>();

              ;
            }
          : null,
      child: GestureDetector(
        onTap: () {
          if (enableTap) backgroundTap(context);
        },
        child: Obx(
          () => Stack(
            fit: StackFit.expand,
            children: [
              child,
              if (controller.isLoading.value)
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                  child: PlainLoadingWidget(
                    onCancel: onCancel,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class PlainLoadingWidget extends StatelessWidget {
  const PlainLoadingWidget({Key? key, this.onCancel}) : super(key: key);

  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator(
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          // ),
          WaveLoading(),
          SizedBox(
            height: 24,
          ),
          Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              decoration: TextDecoration.none,
            ),
          ),

          if (onCancel != null) ...[
            SizedBox(
              height: 24,
            ),
            NeumorphicIconButton(
              icon: Icon(
                Icons.close,
              ),
              color: Colors.white.withOpacity(0.4),
              onPressed: () {
                onCancel!();
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
            )
          ]
        ],
      ),
    );
  }
}

class WaveLoading extends StatelessWidget {
  const WaveLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: Color(0xffffffff),
      size: 30,
    );
  }
}

class LoadingCellWidget extends StatelessWidget {
  const LoadingCellWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
          child: CupertinoActivityIndicator(
        radius: 12.0,
      )),
    );
  }
}
