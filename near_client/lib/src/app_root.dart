import 'package:get/get.dart';
import 'package:getx_near/src/screen/auth/login/login_screen.dart';
import 'package:getx_near/src/screen/auth/signup/signup_screen.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/message/message_screen.dart';
import 'package:getx_near/src/screen/posts/my_posts/relation_comments/relation_comments_screen.dart';
import 'package:getx_near/src/screen/posts/post_add/add_post_controller.dart';
import 'package:getx_near/src/screen/posts/post_add/add_post_screen.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_screen.dart';
import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_controller.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_screen.dart';

class AppRoot {
  static final List<GetPage> pages = [
    ..._authPages,
    ..._mainPages,
    ..._postPages,
    ..._messagePages,
  ];
}

final List<GetPage> _authPages = [
  GetPage(
    name: LoginScreen.routeName,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: SignUpScreen.routeName,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: UserEditScreen.routeName,
    page: () => UserEditScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(
        () => UserEditController(),
      ),
    ),
  ),
];

final List<GetPage> _mainPages = [
  GetPage(
    name: RootScreen.routeName,
    page: () => RootScreen(),
  ),
  GetPage(
    name: MainTabScreen.routeName,
    page: () => MainTabScreen(),
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

final List<GetPage> _postPages = [
  GetPage(
    name: PostDettailScreen.routeName,
    page: () => PostDettailScreen(),
    binding: BindingsBuilder(
      () => Get.lazyPut(
        () => PostDetailController(),
      ),
    ),
  ),
  GetPage(
    name: RelationCommentsScreen.routeName,
    page: () => RelationCommentsScreen(),
    fullscreenDialog: true,
  ),
];

final List<GetPage> _messagePages = [
  GetPage(
    name: MessageScreen.routeName,
    page: () => MessageScreen(),
  )
];
