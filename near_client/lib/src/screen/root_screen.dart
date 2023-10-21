import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:getx_near/main.dart';
import 'package:getx_near/src/screen/auth/auth_tab_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';

RxBool topLoading = false.obs;

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    if (isJailBroken) {
      return const Scaffold(
        body: Center(
          child: Text("JailBrokenが検出されました"),
        ),
      );
    }

    return GetX<AuthService>(
      init: AuthService(),
      builder: (service) {
        return Stack(
          children: [
            ...[
              if (service.currentUser.value != null)
                const MainTabScreen()
              else
                const AuthTabScreen(),
            ],
            if (topLoading.value)
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
                child: const PlainLoadingWidget(),
              )
          ],
        );
      },
    );
  }
}
