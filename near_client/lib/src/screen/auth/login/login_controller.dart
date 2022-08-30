import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/model/utils/response_api.dart';
import 'package:getx_near/src/model/user.dart';

import 'package:getx_near/src/screen/auth/reset_password/reset_password_screen.dart';
import 'package:getx_near/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/notification_service.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserAPI _userAPI = UserAPI();
  bool acceptTerms = false;

  RxBool get buttonEnale {
    return (emailController.text != "" && passwordController.text != "").obs;
  }

  @override
  void onInit() async {
    super.onInit();

    acceptTerms = await StorageKey.checkTerms.loadBool() ?? false;
  }

  Future<void> setTerms(BuildContext context) async {
    if (!acceptTerms) return;
    await StorageKey.checkTerms.saveBool(true);
    Navigator.pop(context);
  }

  Future<void> login() async {
    if (!buttonEnale.value) return;

    topLoading.call(true);

    try {
      final fcm = await NotificationService.to.getFCMToken();

      if (fcm == null) throw Exception("Can't get FCM");

      final authData = {
        "email": emailController.text,
        "password": passwordController.text,
        "fcmToken": fcm,
      };

      final res = await _userAPI.login(authData);
      if (!res.status) return;

      final userData = res.data["user"];
      final token = res.data["token"];

      final user = User.fromMap(userData);
      user.sessionToken = token;
      await Future.delayed(Duration(seconds: 1));

      await AuthService.to.updateUser(user);
    } catch (e) {
      showError(e.toString());
    } finally {
      topLoading.call(false);
    }
  }

  Future<void> showSignUpScreen() async {
    final result = await Get.toNamed(SignUpScreen.routeName);

    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(
        title: "ユーザー登録を完了しました",
        message: "ログインお願い致します。",
      );
    }
  }

  Future<void> showResetPassword() async {
    final bool isEditPassword = true;
    final _res = await Get.toNamed(ResetPasswordAndEmailScreen.routeName,
        arguments: isEditPassword);

    if (_res is ResponseAPI) {
      final user = User.fromMap(_res.data);
      emailController.text = user.email;
    }
  }
}
