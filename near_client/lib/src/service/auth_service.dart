import 'package:get/get.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/recent/recent_controller.dart';
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

    // set home
    currentUser.call(User.fromMap(value!));
    _registerMustControllers();
    print(currentUser.value.toString());
  }

  Future<void> updateUser(User newUser) async {
    newUser.sessionToken ??= currentUser.value!.sessionToken;

    // set home
    await StorageKey.user.saveString(newUser.toMap());
    // set login email(String)
    await StorageKey.loginEmail.saveString(newUser.email);
    currentUser.call(newUser);

    _registerMustControllers();
  }

  Future<void> logout() async {
    await Get.deleteAll();
    await deleteStorageLogout();
    currentUser.value = null;
    print("DELETE");
  }

  void _registerMustControllers() {
    if (!Get.isRegistered<RecentController>()) Get.put(RecentController());
  }
}
