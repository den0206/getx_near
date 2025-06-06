import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/neumorphic_style.dart';
import 'package:sizer/sizer.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});
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

    return GetBuilder<MainTabController>(
      init: MainTabController(),
      autoRemove: false,
      builder: (controller) {
        // チュートリアルの表示
        if (!controller.readTutolial) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async => await controller.showTutorial(context),
          );
        }

        return Scaffold(
          body: !controller.isExistMap
              ? controller.currentPages[controller.currentIndex]
              : IndexedStack(
                  index: controller.currentIndex,
                  children: controller.currentPages,
                ),
          bottomNavigationBar: controller.currentIndex != 2
              ? Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: kBottomNavigationBarHeight,
                  decoration: BoxDecoration(color: ConstsColor.mainBackColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: bottomIcons
                        .asMap()
                        .entries
                        .map(
                          (entry) => NeumorphicRadio(
                            padding: const EdgeInsets.all(10),
                            style: commonRatioStyle(),
                            value: entry.key,
                            groupValue: controller.currentIndex,
                            onChanged: (int? index) {
                              if (index == null) return;
                              controller.setIndex(index);
                            },
                            child: Icon(entry.value, size: 25.sp),
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
