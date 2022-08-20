import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/user_delete/user_delete_screen.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/storage_service.dart';

import '../../../api/user_api.dart';
import '../../main_tab/main_tab_controller.dart';

class UserDetailController extends GetxController {
  User user;
  LocationDetail currentSize = LocationDetail.high;
  final currentUser = AuthService.to.currentUser.value!;
  final UserAPI _userAPI = UserAPI();

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
            // map screnn からの退避
            if (MainTabController.to.currentIndex ==
                MainTabController.to.mapIndex) {
              MainTabController.to.setIndex(0);
            }
            // root に戻す
            if (Navigator.canPop(context))
              Navigator.popUntil(context, (route) => route.isFirst);

            // ログアウト
            AuthService.to.logout();
          },
        );
      },
    );
  }

  Future<void> showDeleteScreen() async {
    final _ = await Get.toNamed(UserDeleteScreen.routeName);
  }

  Future<void> blockUser() async {
    if (user.isCurrent) return;

    try {
      if (currentUser.checkBlock(user)) {
        currentUser.blockedUsers.remove(user.id);
      } else {
        currentUser.blockedUsers.add(user.id);
      }

      final Map<String, dynamic> data = {
        "blocked": currentUser.blockedUsers.toSet().toList()
      };

      final res = await _userAPI.updateBlock(userData: data);
      if (!res.status) return;

      final newUser = User.fromMap(res.data);
      await AuthService.to.updateUser(newUser);

      isBlocked = !isBlocked;
      update();
    } catch (e) {
      showError(e.toString());
    }
  }
}
