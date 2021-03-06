import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../service/location_service.dart';
import '../../../utils/consts_color.dart';
import '../../widget/neumorphic/nicon_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
        actions: [
          NeumorphicIconButton(
            iconData: Icons.close,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: GetBuilder<UserDetailController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _selectLocationArea(controller),
              SizedBox(
                height: 10,
              ),
              ListView(
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
                      title: Text("レビュー"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("お問い合わせ"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ],
                ).toList(),
              )
            ],
          );
        },
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
            style:
                NeumorphicToggleStyle(backgroundColor: ConstsColor.panelColor),
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
                color: ConstsColor.panelColor,
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
