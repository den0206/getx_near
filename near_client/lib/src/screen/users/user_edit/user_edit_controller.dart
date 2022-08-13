import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/service/auth_service.dart';
import '../../../api/user_api.dart';
import '../../../model/user.dart';
import '../../../service/image_extention.dart';
import '../../auth/reset_password/reset_password_screen.dart';
import '../../widget/loading_widget.dart';

class UserEditController extends LoadingGetController {
  final User currentUser = AuthService.to.currentUser.value!;
  late final User editUser;
  final UserAPI _userAPI = UserAPI();

  Rxn<File> userImage = Rxn<File>();
  final TextEditingController nameController = TextEditingController();

  RxBool get isChanged {
    if (editUser.name.isEmpty) return false.obs;

    if (userImage.value != null || currentUser.name != editUser.name) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    editUser = currentUser.copyWith();
    nameController.text = editUser.name;
  }

  Future<void> selectImage(BuildContext context) async {
    try {
      final avatar = await ImageExtention.pickSingleImage(context);
      if (avatar != null) {
        userImage.call(avatar);
        print("サイズ :${avatar.lengthSync()} ");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUser() async {
    if (!isChanged.value || isLoading.value) return;
    isLoading.call(true);
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final res = await _userAPI.updateUser(
          updateData: editUser.toMap(), avatarFile: userImage.value);

      if (!res.status) return;
      final newUser = User.fromMap(res.data);

      await AuthService.to.updateUser(newUser);

      // Tips update same url image
      if (newUser.avatarUrl != null)
        newUser.avatarUrl = "${newUser.avatarUrl}?v=${Random().nextInt(1000)}";

      Get.back(result: newUser);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> showEditEmail() async {
    final bool isEditPassword = false;
    Get.toNamed(
      ResetPasswordAndEmailScreen.routeName,
      arguments: isEditPassword,
    );
  }
}
