import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/report_api.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/protect_home/protect_home_screen.dart';
import 'package:getx_near/src/screen/users/user_delete/user_delete_screen.dart';
import 'package:getx_near/src/screen/users/user_detail/settings/blocks/block_list_screen.dart';
import 'package:getx_near/src/screen/users/user_detail/settings/contacts/contact_screen.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_screen.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/storage_service.dart';
import 'package:getx_near/src/utils/date_formate.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../api/user_api.dart';
import '../../main_tab/main_tab_controller.dart';

class UserDetailController extends GetxController {
  User user;

  final currentUser = AuthService.to.currentUser.value!;
  final UserAPI _userAPI = UserAPI();
  final ReportAPI _reportAPI = ReportAPI();

  bool isBlocked = false;
  int reportedCount = 0;
  String? currentVersion;
  UserDetailController(this.user);

  LocationDetail currentSize = LocationDetail.high;
  int get locationIndex {
    return LocationDetail.values.indexOf(currentSize);
  }

  final RxDouble currentDistance = kMinDistance.toDouble().obs;
  int get searchDistance {
    return currentDistance.value.round();
  }

  String get createdAtOnFormat {
    return DateFormatter.getCreatedAtString(user.createdAt);
  }

  @override
  void onInit() async {
    super.onInit();
    isBlocked = currentUser.checkBlock(user);
    await _getReportedCount();
    await _getLocalStorage();
    await _getInfo();

    // 更新
    update();
  }

  Future<void> _getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
  }

  Future<void> _getLocalStorage() async {
    // Location
    final localLoc =
        getLocationDetail(await StorageKey.locationSize.loadString());
    currentSize = localLoc;

    // search Radius
    final int localDistance = getNotificationDistance(
        await StorageKey.notificationDistance.loadInt());

    currentDistance.call(localDistance.roundToDouble());
  }

  Future<void> setLocalLoc(int value) async {
    final temp = LocationDetail.values[value];
    currentSize = temp;

    update();
    await StorageKey.locationSize.saveString(temp.name);
  }

  Future<void> setLocalDistance() async {
    await StorageKey.notificationDistance.saveInt(searchDistance);
  }

  Future<void> pushContactPage() async {
    await Get.toNamed(ContactScreen.routeName);
  }

  Future<void> pushBlockListPage() async {
    await Get.toNamed(BlockListScreen.routeName);
  }

  Future<void> pushEditPage() async {
    if (!user.isCurrent) return;
    final result = await Get.toNamed(UserEditScreen.routeName);

    if (result is User) {
      user = result;
      update();
    }
  }

  Future<void> _getReportedCount() async {
    try {
      final res = await _reportAPI.getReportedCount(userId: user.id);
      reportedCount = int.parse(res.data);

      if (!res.status) return;
    } catch (e) {
      showError(e.toString());
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
    if (!user.isCurrent) return;
    final _ = await Get.toNamed(UserDeleteScreen.routeName);
  }

  Future<void> showProtectHomeScreen() async {
    if (!user.isCurrent) return;
    final _ = await Get.toNamed(ProtectHomeScreen.routeName);
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
