import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:getx_near/src/screen/auth/auth_tab_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:getx_near/src/service/auth_service.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      init: AuthService(),
      builder: (service) {
        if (service.currentUser.value != null) {
          return MainTabScreen();
        } else {
          return AuthTabScreen();
        }
      },
    );
  }
}
