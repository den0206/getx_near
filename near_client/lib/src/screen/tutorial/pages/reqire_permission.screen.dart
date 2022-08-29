import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';

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
        return Color.fromARGB(255, 249, 154, 38);
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
        CustomButton(
          title: "${type.title} を許可する",
          background: type.mainColor,
          onPressed: onPress,
        )
      ],
    );
  }
}
