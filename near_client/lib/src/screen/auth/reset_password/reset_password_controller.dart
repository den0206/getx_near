import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

import '../../../api/temp_token_api.dart';
import '../../../api/user_api.dart';
import '../../../model/user.dart';
import '../../../service/auth_service.dart';
import '../../../utils/global_functions.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_pin.dart';
import '../../widget/loading_widget.dart';

class ResetPasswordAndEmailController extends LoadingGetController {
  VerifyState state = VerifyState.checkEmail;
  final TextEditingController emailTextField = TextEditingController();
  final TextEditingController passwordTextField = TextEditingController();
  final TextEditingController pinTextField = TextEditingController();

  final _tempTokenAPI = TempTokenAPI();
  final _userAPI = UserAPI();

  late final String userId;

  final bool isEditPassword = Get.arguments ?? false;
  bool buttonEnable = false;

  TextEditingController get currentTx {
    switch (state) {
      case VerifyState.checkEmail:
        return emailTextField;
      case VerifyState.sendPassword:
        return passwordTextField;
      case VerifyState.verify:
        return pinTextField;
    }
  }

  @override
  void onInit() {
    super.onInit();
    print(isEditPassword);
  }

  Future<void> sendRequest() async {
    if (currentTx.text == "") return;

    isLoading.call(true);
    await Future.delayed(const Duration(seconds: 1));

    try {
      switch (state) {
        case VerifyState.checkEmail:
          if (isEditPassword) {
            state = VerifyState.sendPassword;
          } else {
            final res = await _tempTokenAPI.requestNewEmail(
              emailTextField.text,
            );
            if (!res.status) break;
            buttonEnable = false;
            state = VerifyState.verify;
          }
          break;
        case VerifyState.sendPassword:
          if (isEditPassword) {
            final res = await _tempTokenAPI.requestPassword(
              emailTextField.text,
            );

            if (res.message != null &&
                res.message!.contains("Not find this Email")) {
              passwordTextField.clear();
              state = VerifyState.checkEmail;
            }

            if (!res.status) break;
            userId = res.data;
            state = VerifyState.verify;
          }
          break;
        case VerifyState.verify:
          final ResponseAPI res;

          if (isEditPassword) {
            final data = {
              "userId": userId,
              "password": passwordTextField.text,
              "verify": pinTextField.text,
            };

            res = await _tempTokenAPI.verifyPassword(data);
            if (!res.status) break;
          } else {
            final Map<String, dynamic> data = {
              "email": emailTextField.text,
              "verify": pinTextField.text,
            };
            final checkRes = await _tempTokenAPI.verifyEmail(data);
            if (!checkRes.status) break;

            res = await _userAPI.updateUser(updateData: data);
            if (!res.status) break;
            final newUser = User.fromMap(res.data);
            await AuthService.to.updateUser(newUser);
          }

          Get.back(result: res);

          showSnackBar(
            title: isEditPassword ? "Change Password" : "Change Email",
            message: "Keep Mind",
          );
          break;
      }
    } catch (e) {
      if (e.toString() == "Error During Communication: Not find this Email") {
        state = VerifyState.checkEmail;
        emailTextField.clear();
        passwordTextField.clear();
      }
      showError(e.toString());
    } finally {
      isLoading.call(false);
      buttonEnable = false;
      update();
    }
  }

  void checkField(String value) {
    buttonEnable = value.length >= state.minLength;

    update();
  }
}
