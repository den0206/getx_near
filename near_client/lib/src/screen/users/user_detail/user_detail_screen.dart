import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';

import '../../widget/neumorphic/nicon_button.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserDetailController>(
      init: UserDetailController(user),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
            actions: [
              if (user.isCurrent)
                NeumorphicIconButton(
                  iconData: Icons.settings,
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: ConstsColor.panelColor,
                      builder: (context) {
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
                                  children: [
                                    Text("位置情報の正確差"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    NeumorphicToggle(
                                      selectedIndex: controller.locationIndex,
                                      displayForegroundOnlyIfSelected: true,
                                      style: NeumorphicToggleStyle(
                                          backgroundColor:
                                              ConstsColor.panelColor),
                                      children: LocationDetail.values.map((l) {
                                        return ToggleElement(
                                          background: Center(
                                              child: Text(
                                            l.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )),
                                          foreground: Center(
                                              child: Text(
                                            l.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          )),
                                        );
                                      }).toList(),
                                      thumb: Neumorphic(
                                        style: NeumorphicStyle(
                                          color: ConstsColor.panelColor,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
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
                                );
                              },
                            ));
                      },
                    );
                  },
                )
            ],
          ),
          body: Neumorphic(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            style: NeumorphicStyle(
              color: ConstsColor.panelColor,
              shadowLightColor: Colors.black54,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Neumorphic(
                    padding: EdgeInsets.all(10),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      color: ConstsColor.panelColor,
                      // depth: NeumorphicTheme.embossDepth(context),
                    ),
                    child: CircleImageButton(
                        imageProvider: getUserImage(user), size: 120),
                  ),
                  NeumorphicText(
                    user.name,
                    style: NeumorphicStyle(
                      color: ConstsColor.panelColor,
                      intensity: 1,
                      shadowLightColor: Colors.black,
                      lightSource: LightSource.bottomRight,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        width: 35.w,
                        height: 7.h,
                        titleColor: Colors.white,
                        background: Colors.green,
                        title: "Edit",
                        shadowColor: Colors.black54,
                        onPressed: () {},
                      ),
                      CustomButton(
                        width: 35.w,
                        height: 7.h,
                        titleColor: Colors.white,
                        background: Colors.red,
                        title: "Log out",
                        shadowColor: Colors.black54,
                        onPressed: () {
                          controller.tryLogout(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
