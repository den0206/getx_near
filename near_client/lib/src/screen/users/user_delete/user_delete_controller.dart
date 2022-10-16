import 'package:flutter/material.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/storage_service.dart';

import '../../../service/auth_service.dart';
import '../../main_tab/main_tab_controller.dart';
import '../../widget/loading_widget.dart';

class UserDeleteController extends LoadingGetController {
  final currentUser = AuthService.to.currentUser.value!;

  Future<void> tryDelete(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Delete User",
          descripon: "continue?",
          icon: Icons.delete,
          mainColor: Colors.red,
          onPress: () async {
            await _deleteUser(context);
          },
        );
      },
    );
  }

  Future<void> _deleteUser(BuildContext context) async {
    if (MainTabController.to.currentIndex == MainTabController.to.mapIndex) {
      MainTabController.to.setIndex(0);
    }
    if (Navigator.canPop(context)) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }

    topLoading.call(true);

    try {
      final _userAPI = UserAPI();
      await Future.delayed(const Duration(seconds: 1));

      final res = await _userAPI.deleteUser();
      if (!res.status) return;

      // ログアウト
      await AuthService.to.logout();
      await deleteAllStorage();
    } catch (e) {
      showError(e.toString());
    } finally {
      topLoading.call(false);
    }
  }
}
