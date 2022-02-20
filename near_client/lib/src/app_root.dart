import 'package:get/get.dart';
import 'package:getx_near/src/screen/get_address/get_address_screen.dart';
import 'package:getx_near/src/screen/main_tab/add_post/add_post_controller.dart';
import 'package:getx_near/src/screen/main_tab/add_post/add_post_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';

class AppRoot {
  static final List<GetPage> pages = [..._mainPages];
}

final List<GetPage> _mainPages = [
  GetPage(
    name: MainTabScreen.routeName,
    page: () => MainTabScreen(),
  ),
  GetPage(
    name: GetAddressScreen.routeName,
    page: () => GetAddressScreen(),
  ),
  GetPage(
    name: AddPostScreen.routeName,
    page: () => AddPostScreen(),
    fullscreenDialog: true,
    binding: BindingsBuilder(
      () => Get.lazyPut(
        () => AddPostController(),
      ),
    ),
  ),
  GetPage(
    name: MapScreen.routeName,
    page: () => MapScreen(),
  )
];
