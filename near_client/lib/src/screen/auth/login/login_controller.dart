import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/model/utils/response_api.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';

class LoginController extends LoadingGetController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserAPI _userAPI = UserAPI();

  RxBool get buttonEnale {
    return (emailController.text != "" && passwordController.text != "").obs;
  }

  @override
  void onClose() {
    super.onClose();
    print("Close Login");
  }

  Future<void> login() async {
    if (!buttonEnale.value) return;

    final authData = {
      "email": emailController.text,
      "password": passwordController.text
    };

    isLoading.call(true);

    try {
      final res = await _userAPI.login(authData);
      if (!res.status) return;

      final userData = res.data["user"];
      final token = res.data["token"];

      final user = User.fromMap(userData);
      user.sessionToken = token;
      await Future.delayed(Duration(seconds: 1));
      await Get.delete<LoginController>();

      await AuthService.to.updateUser(user);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> showSignUpScreen() async {
    final result = await Get.toNamed(SignUpScreen.routeName);

    if (result is ResponseAPI) {
      final user = User.fromMap(result.data);
      emailController.text = user.email;

      showSnackBar(title: "Lets Login");
    }
  }
}
