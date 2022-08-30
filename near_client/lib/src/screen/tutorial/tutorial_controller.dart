import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/tutorial/pages/reqire_permission.screen.dart';
import 'package:getx_near/src/screen/tutorial/pages/welcome_screen.dart';
import 'package:getx_near/src/screen/users/protect_home/protect_home_screen.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/global_functions.dart';

import '../../service/notification_service.dart';
import '../../service/permission_service.dart';

class TutorialController extends GetxController {
  final PageController pageController;
  final ValueNotifier<double> notifier;

  TutorialController(this.pageController, this.notifier);

  bool get isFirst => notifier.value == 0;
  bool get isLast => notifier.value == pages.length - 1;
  int get currentIndex {
    if (!pageController.hasClients || pageController.page == null) return 0;
    return pageController.page!.round();
  }

  Color get currentCollor => backColors[currentIndex];

  List<Widget> get pages {
    return [
      WelcomeScreen(),
      PermissionTutorialScreen(
        type: PermissionType.notification,
        onPress: () async {
          await checkPermission(PermissionType.notification);
        },
      ),
      PermissionTutorialScreen(
        type: PermissionType.location,
        onPress: () async {
          await checkPermission(
            PermissionType.location,
          );
        },
      ),
      ProtectHomeScreen(
        isTutorial: true,
      ),
    ];
  }

  List<Color> get backColors {
    return [
      ConstsColor.mainBackColor,
      ConstsColor.mainGreenColor!,
      ConstsColor.mainOrangeColor,
      ConstsColor.mainBackColor,
    ];
  }

  @override
  void onInit() {
    pageController..addListener(_onScroll);
    super.onInit();
  }

  _onScroll() {
    notifier.value = pageController.page ?? 0;
    update();
  }

  Future<void> checkPermission(PermissionType type) async {
    switch (type) {
      case PermissionType.notification:
        await NotificationService.to.requestPermission();
        break;
      case PermissionType.location:
        final service = PermissionService();
        await service.checkLocation();
        break;
    }
  }

  Future<void> changePage(BuildContext context, {bool isBack = false}) async {
    if (isLast && !isBack) {
      await StorageKey.loginTutolial.saveBool(true);
      Navigator.of(context).pop();

      showSnackBar(
        title: "Welcome",
        message: "チュートリアルが完了しました",
        background: ConstsColor.mainOrangeColor,
      );

      return;
    }
    ;
    !isBack
        ? await pageController.nextPage(
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          )
        : await pageController.previousPage(
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          );
  }
}
