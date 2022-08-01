import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:getx_near/src/screen/auth/auth_tab_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';

RxBool topLoading = false.obs;

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);
  static const routeName = '/Root';

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      init: AuthService(),
      builder: (service) {
        return Stack(
          children: [
            ...[
              if (service.currentUser.value != null)
                MainTabScreen()
              else
                AuthTabScreen(),
            ],
            if (topLoading.value)
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
                child: PlainLoadingWidget(),
              )
          ],
        );
      },
    );
  }
}
