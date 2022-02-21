import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';

class SignUpController extends LoadingGetController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserAPI _userAPI = UserAPI();

  RxBool get buttonEnable {
    return (nameController.text != "" &&
            emailController.text != "" &&
            passwordController.text != "")
        .obs;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> signUp() async {
    if (!buttonEnable.value) return;

    final userData = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text
    };

    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final res = await _userAPI.signUp(userData);
      if (!res.status) return;

      Get.back(result: res);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
