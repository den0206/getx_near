import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/storage_service.dart';

class UserDetailController extends GetxController {
  final User user;
  LocationDetail currentSize = LocationDetail.high;
  int get locationIndex {
    return LocationDetail.values.indexOf(currentSize);
  }

  UserDetailController(this.user);

  @override
  void onInit() async {
    super.onInit();
    await getLocalLoc();
  }

  Future<void> getLocalLoc() async {
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
