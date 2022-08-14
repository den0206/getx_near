import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/storage_service.dart';

class UserDetailController extends GetxController {
  User user;
  LocationDetail currentSize = LocationDetail.high;
  final currentUser = AuthService.to.currentUser.value!;

  bool isBlocked = false;
  UserDetailController(this.user);

  int get locationIndex {
    return LocationDetail.values.indexOf(currentSize);
  }

  @override
  void onInit() async {
    super.onInit();
    isBlocked = currentUser.checkBlock(user);
    await _getLocalLoc();
  }

  Future<void> _getLocalLoc() async {
    final localLoc =
        getLocationDetail(await StorageKey.locationSize.loadString());
    currentSize = localLoc;
    update();
  }

  Future<void> setLocalLoc(int value) async {
    final temp = LocationDetail.values[value];
    currentSize = temp;

    update();
    await StorageKey.locationSize.saveString(temp.name);
  }

  Future<void> pushEditPage() async {
    if (!user.isCurrent) return;
    final result = await Get.toNamed(UserEditScreen.routeName);

    if (result is User) {
      user = result;
      update();
    }
  }

  Future<void> tryLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Logout",
          descripon: "continue?",
          icon: Icons.logout,
          mainColor: Colors.red,
          onPress: () {
            AuthService.to.logout();
          },
        );
      },
    );
  }
}
