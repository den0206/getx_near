import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../../service/location_service.dart';
import '../../../../utils/consts_color.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: GetBuilder<UserDetailController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _selectLocationArea(controller),
                Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("通知範囲"),
                            Text(
                              "${controller.searchDistance} m",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        NeumorphicSlider(
                          min: kMinDistance.toDouble(),
                          max: kMaxDistance.toDouble(),
                          value: controller.currentDistance.value,
                          style: SliderStyle(
                            variant: ConstsColor.mainBackColor,
                            accent: controller.user.sex.mainColor,
                            depth: 1,
                          ),
                          sliderHeight: 30,
                          onChanged: (percent) {
                            controller.currentDistance.value = percent;
                          },
                          onChangeEnd: (percent) async {
                            await controller.setLocalDistance();
                          },
                        ),
                      ],
                    ))),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  child: ListView(
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: Text("通知"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            openAppSettings();
                          },
                        ),
                        ListTile(
                          title: Text("Version"),
                          trailing:
                              Text(controller.currentVersion ?? "Unknown"),
                        ),
                        ListTile(
                          title: Text("ブロック一覧"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await controller.pushBlockListPage();
                          },
                        ),
                        ListTile(
                          title: Text("クリアキャッシュ"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await DefaultCacheManager().emptyCache();
                          },
                        ),
                        ListTile(
                          title: Text("お問い合わせ"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await controller.pushContactPage();
                          },
                        ),
                        ListTile(
                          title: Text("ログアウト"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.of(context).pop();
                            controller.tryLogout(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            "ユーザー削除",
                            style: TextStyle(color: Colors.red),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.of(context).pop();
                            controller.showDeleteScreen();
                          },
                        ),
                      ],
                    ).toList(),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _selectLocationArea(UserDetailController controller) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text("位置情報の正確さ"),
          SizedBox(
            height: 20,
          ),
          NeumorphicToggle(
            selectedIndex: controller.locationIndex,
            displayForegroundOnlyIfSelected: true,
            style: NeumorphicToggleStyle(
                backgroundColor: ConstsColor.mainBackColor),
            children: LocationDetail.values.map((l) {
              return ToggleElement(
                background: Center(
                    child: Text(
                  l.title,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
                foreground: Center(
                    child: Text(
                  l.title,
                  style: TextStyle(fontWeight: FontWeight.w700),
                )),
              );
            }).toList(),
            thumb: Neumorphic(
              style: NeumorphicStyle(
                color: ConstsColor.mainBackColor,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
            onChanged: (int index) {
              controller.setLocalLoc(index);
            },
          ),
        ],
      ),
    );
  }
}