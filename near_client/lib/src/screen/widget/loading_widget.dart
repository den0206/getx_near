import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/utils/global_functions.dart';

abstract class LoadingGetController extends GetxController {
  final RxBool isLoading = false.obs;
}

abstract class LoadingGetView<T extends LoadingGetController>
    extends GetView<T> {
  T get ctr;
  final bool isFenix = false;
  Widget get child;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<T>()) Get.lazyPut(() => ctr, fenix: isFenix);

    return GestureDetector(
      onTap: () {
        dismisskeyBord(context);
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
                child: PlainLoadingWidget(),
              )
          ],
        ),
      ),
    );
  }
}

class PlainLoadingWidget extends StatelessWidget {
  const PlainLoadingWidget({Key? key}) : super(key: key);

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
          )
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
