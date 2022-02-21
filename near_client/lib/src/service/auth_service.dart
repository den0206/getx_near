import 'package:get/get.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/service/storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final Rxn<User> currentUser = Rxn<User>();

  @override
  void onInit() async {
    super.onInit();
    await loadUser();
  }

  Future<void> loadUser() async {
    if (currentUser.value != null) return;
    final value = await StorageKey.user.loadString();
    if (value == null) return;

    this.currentUser.call(User.fromMap(value!));
    print(currentUser.value.toString());
  }

  Future<void> updateUser(User newUser) async {
    if (newUser.sessionToken == null)
      newUser.sessionToken = currentUser.value!.sessionToken;
    await StorageKey.user.saveString(newUser.toMap());
    this.currentUser.call(newUser);
  }

  Future<void> logout() async {
    await Get.delete<MainTabController>();
    if (Get.isRegistered<MapController>()) await Get.delete<MapController>();
    if (Get.isRegistered<MainSlidePanelController>())
      await Get.delete<MainSlidePanelController>();

    await StorageKey.user.deleteLocal();
    this.currentUser.value = null;
    print("DELETE");
  }
}
