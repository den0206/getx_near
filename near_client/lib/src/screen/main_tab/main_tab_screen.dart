import 'package:getx_near/src/utils/neumorphic_style.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_screen.dart';
import 'package:getx_near/src/screen/recent/recent_screen.dart';
import 'package:getx_near/src/screen/sos/sos_screen.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_screen.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);
  static const routeName = '/Maintab';

  @override
  Widget build(BuildContext context) {
    final List<IconData> bottomIcons = [
      Icons.speaker_phone,
      Icons.list,
      Icons.map,
      Icons.message,
      Icons.person,
    ];

    final List<Widget> pages = [
      SOSScreen(),
      MyPostsScreen(),
      MapScreen(),
      RecentScreen(),
      UserDetailScreen(
        user: AuthService.to.currentUser.value!,
      ),
    ];

    return GetBuilder<MainTabController>(
      init: MainTabController(),
      autoRemove: false,
      builder: (controller) {
        return Scaffold(
          body: !Get.isRegistered<MapController>()
              ? pages[controller.currentIndex]
              : IndexedStack(
                  index: controller.currentIndex,
                  children: pages,
                ),
          bottomNavigationBar: controller.currentIndex != 2
              ? Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: kBottomNavigationBarHeight,
                  decoration: BoxDecoration(color: ConstsColor.mainBackColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: bottomIcons
                        .asMap()
                        .entries
                        .map(
                          (entry) => NeumorphicRadio(
                            padding: EdgeInsets.all(10),
                            style: commonRatioStyle(),
                            child: Icon(
                              entry.value,
                              size: 25.sp,
                            ),
                            value: entry.key,
                            groupValue: controller.currentIndex,
                            onChanged: (int? index) {
                              if (index == null) return;
                              controller.setIndex(index);
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
              : null,
        );
      },
    );
  }
}


 // final bottomItems = [
    //   BottomNavigationBarItem(
    //     label: "SOS",
    //     icon: Icon(
    //       Icons.speaker_phone,
    //     ),
    //   ),
    //   BottomNavigationBarItem(
    //     label: "List",
    //     icon: Icon(
    //       Icons.list,
    //     ),
    //   ),
    //   BottomNavigationBarItem(
    //     label: "Map",
    //     icon: Icon(Icons.map),
    //   ),
    //   BottomNavigationBarItem(
    //     label: "Message",
    //     icon: Icon(
    //       Icons.message,
    //     ),
    //   ),
    //   BottomNavigationBarItem(
    //     label: "Profile",
    //     icon: Icon(
    //       Icons.person,
    //     ),
    //   ),
    // ];

        // bottomNavigationBar: controller.currentIndex != 2
        //       ? BottomNavigationBar(
        //           backgroundColor: Colors.grey,
        //           selectedItemColor: Colors.black,
        //           elevation: 0,
        //           onTap: controller.setIndex,
        //           type: BottomNavigationBarType.fixed,
        //           currentIndex: controller.currentIndex,
        //           items: bottomItems,
        //         )
        //       : null,