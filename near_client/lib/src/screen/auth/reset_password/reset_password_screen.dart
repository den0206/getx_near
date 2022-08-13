import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/screen/auth/reset_password/reset_password_controller.dart';

import '../../widget/custom_pin.dart';
import '../../widget/loading_widget.dart';

class ResetPasswordAndEmailScreen
    extends LoadingGetView<ResetPasswordAndEmailController> {
  static const routeName = '/ResetPasswordAndEmail';
  @override
  ResetPasswordAndEmailController get ctr => ResetPasswordAndEmailController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_ResetPasswordState');

  @override
  Widget get child {
    return GetBuilder<ResetPasswordAndEmailController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.state.title),
            foregroundColor: Colors.black,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Form(
            key: _formKey,
            child: PinCodeArea(
              currentState: controller.state,
              currentTX: controller.currentTx,
              onChange: controller.checkField,
              onPressed: !controller.buttonEnable
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false)
                        controller.sendRequest();
                    },
            ),
          ),
        );
      },
    );
  }
}
