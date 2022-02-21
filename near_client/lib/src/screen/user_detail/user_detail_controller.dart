import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';

class UserDetailController extends GetxController {
  final User user;

  UserDetailController(this.user);

  Future<void> tryLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Logout",
          descripon: "continue?",
          icon: Icons.logout,
          mainColor: Colors.red,
          onPress: () {
            AuthService.to.logout();
          },
        );
      },
    );
  }
}
