import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({Key? key}) : super(key: key);
  static const routeName = '/Maintab';

  @override
  Widget build(BuildContext context) {
    final bottomItems = [
      BottomNavigationBarItem(
        label: "Profile",
        icon: Icon(
          Icons.person,
        ),
      ),
      BottomNavigationBarItem(
        label: "Map",
        icon: Icon(Icons.map),
      ),
      BottomNavigationBarItem(
        label: "Message",
        icon: Icon(
          Icons.message,
        ),
      ),
    ];

    final List<Widget> pages = [
      Text("Sample"),
      MapScreen(),
      Text("Message"),
    ];
    return GetBuilder<MainTabController>(
      init: MainTabController(),
      builder: (controller) {
        return Scaffold(
          body: pages[controller.currentIndex],
          // IndexedStack(
          //   index: controller.currentIndex,
          //   children: pages,
          // ),
          bottomNavigationBar: controller.currentIndex != 1
              ? BottomNavigationBar(
                  backgroundColor: Colors.grey,
                  selectedItemColor: Colors.black,
                  elevation: 0,
                  onTap: controller.setIndex,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.currentIndex,
                  items: bottomItems,
                )
              : null,
        );
      },
    );
  }
}
