import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/consts_color.dart';

enum PermissionType {
  notification,
  location;

  String get title {
    switch (this) {
      case PermissionType.notification:
        return "通知";
      case PermissionType.location:
        return "位置情報";
    }
  }

  Color get mainColor {
    switch (this) {
      case PermissionType.notification:
        return ConstsColor.mainGreenColor!;
      case PermissionType.location:
        return ConstsColor.mainOrangeColor;
    }
  }

  String get description {
    switch (this) {
      case PermissionType.notification:
        return "Push通知の許可をお願い致します。";
      case PermissionType.location:
        return "位置情報取得の許可をお願い致します。";
    }
  }

  String get assetPath {
    switch (this) {
      case PermissionType.notification:
        return "assets/lotties/notification_animation.json";
      case PermissionType.location:
        return "assets/lotties/location_animation.json";
    }
  }
}

class PermissionTutorialScreen extends StatelessWidget {
  const PermissionTutorialScreen({super.key, this.onPress, required this.type});

  final PermissionType type;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          type.assetPath,
          width: 35.h,
          height: 35.h,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          type.description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        CustomButton(
          title: "${type.title} を許可する",
          background: type.mainColor,
          onPressed: onPress,
        )
      ],
    );
  }
}
