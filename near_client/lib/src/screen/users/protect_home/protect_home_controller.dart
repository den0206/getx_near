import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../model/user.dart';
import '../../../service/location_service.dart';

class ProtectHomeController extends GetxController {
  User get currentUser => AuthService.to.currentUser.value!;
  final RxDouble currentDistance = kMinDistance.toDouble().obs;
  int get homeDistance => currentDistance.value.round();

  @override
  void onInit() async {
    super.onInit();
    // homeDistance
    final int localDistance =
        getHomeDistance(await StorageKey.homeDistance.loadInt());

    currentDistance.call(localDistance.roundToDouble());
  }

  Future<void> tryRegisterHome(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "居住地の登録",
          descripon: "現在地を居住地に登録しますか?",
          icon: Icons.home,
          mainColor: ConstsColor.mainGreenColor!,
          onPress: () async {
            await _registerHome();
          },
        );
      },
    );
  }

  Future<void> _registerHome() async {
    try {
      final service = LocationService();
      final Position current = await service.getCurrentPosition();
      final LatLng home = LatLng(current.latitude, current.longitude);

      _updatelocalUser(home: home);
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> tryDeleteHome(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "居住地の削除",
          descripon: "情報が削除されます",
          icon: Icons.home,
          mainColor: Colors.redAccent,
          onPress: () async {
            await _updatelocalUser(home: null);
          },
        );
      },
    );
  }

  Future<void> _updatelocalUser({LatLng? home}) async {
    User copyUser = currentUser.copyWith();
    copyUser.home = home;
    await AuthService.to.updateUser(copyUser);
    update();
  }

  Future<void> setHomeDistance() async {
    await StorageKey.homeDistance.saveInt(homeDistance);
  }
}
