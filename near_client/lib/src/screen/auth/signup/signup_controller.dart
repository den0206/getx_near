import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/temp_token_api.dart';
import 'package:getx_near/src/api/user_api.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/custom_pin.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/image_extention.dart';

import '../../../model/user.dart';

class SignUpController extends LoadingGetController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  File? userImage;

  final UserAPI _userAPI = UserAPI();
  final TempTokenAPI _tempTokenAPI = TempTokenAPI();

  VerifyState state = VerifyState.checkEmail;
  int sexIndex = 0;
  Sex get currentSex {
    return Sex.values[sexIndex];
  }

  bool get buttonEnable {
    // current
    return true;
  }

  Future<void> selectImage(BuildContext context) async {
    try {
      final avatar = await ImageExtention.pickSingleImage(context);
      if (avatar != null) {
        userImage = avatar;
        print("サイズ :${avatar.lengthSync()} ");
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void changeSex(int index) {
    sexIndex = index;
    print(currentSex.name);
    update();
  }

  Future<void> signUp() async {
    if (!buttonEnable) return;
    print(userImage);

    isLoading.call(true);
    await Future.delayed(const Duration(seconds: 1));
    final String emailLower = emailController.text.toLowerCase();
    try {
      switch (state) {
        case VerifyState.checkEmail:
          final res = await _tempTokenAPI.requestNewEmail(emailLower);
          if (!res.status) break;
          state = VerifyState.verify;
          break;
        case VerifyState.verify:
          final userData = {
            "name": nameController.text,
            "email": emailController.text,
            "password": passwordController.text,
            "sex": currentSex.name,
            "createdAt": DateTime.now().toUtc().toIso8601String(),
            "verify": pinCodeController.text,
          };

          // pincodeの確認
          final checkRes = await _tempTokenAPI.verifyEmail(userData);
          if (!checkRes.status) break;

          // New Userの確認
          final res = await _userAPI.signUp(
            userData: userData,
            avatarFile: userImage,
          );
          if (!res.status) return;

          Get.back(result: res);

          break;

        default:
          break;
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.call(false);
      update();
    }
  }
}
