import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_controller.dart';
import 'package:getx_near/src/screen/users/user_detail/user_settings_screen.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/neumorphic_style.dart';
import '../../report/report_screen.dart';
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
            actions: !user.isCurrent
                ? [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeumorphicIconButton(
                        icon: Icon(
                          Icons.emergency_share,
                          color: Colors.red[400],
                        ),
                        onPressed: () async {
                          await showReportScreen(
                            context: context,
                            user: user,
                          );
                        },
                      ),
                    )
                  ]
                : null,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Neumorphic(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                style: commonNeumorphic(depth: 1.6),
                child: Column(
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    NeumorphicAvatarButton(
                      imageProvider: getUserImage(user),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    NeumorphicText(
                      user.name,
                      style: NeumorphicStyle(
                        color: ConstsColor.mainBackColor,
                        intensity: 1,
                        shadowLightColor: Colors.black,
                        lightSource: LightSource.bottomRight,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    if (user.isCurrent) ...[
                      Text(user.email),
                      SizedBox(
                        height: 6.h,
                      ),
                    ],
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: user.isCurrent
                            ? [
                                NeumorphicIconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: 35.sp,
                                    ),
                                    onPressed: () {
                                      controller.pushEditPage();
                                    }),
                                NeumorphicIconButton(
                                    icon: Icon(
                                      Icons.settings,
                                      size: 35.sp,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor:
                                            ConstsColor.mainBackColor,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SettingsScreen();
                                        },
                                      );
                                    }),
                              ]
                            : [
                                NeumorphicIconButton(
                                  icon: Icon(
                                    Icons.block,
                                    color: controller.isBlocked
                                        ? Colors.black
                                        : Colors.red,
                                    size: 40.sp,
                                  ),
                                  depth: controller.isBlocked ? -2 : 1,
                                  onPressed: () {
                                    controller.blockUser();
                                  },
                                ),
                              ]),
                    SizedBox(
                      height: 4.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
