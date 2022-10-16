import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/users/user_detail/settings/user_settings_screen.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_controller.dart';
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
            actions: const [],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Neumorphic(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  style: commonNeumorphic(depth: 1.6),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                      UserAvatarButton(user: user),
                      SizedBox(
                        height: 4.h,
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
                                    Icons.home,
                                    size: 35.sp,
                                  ),
                                  onPressed: () {
                                    controller.showProtectHomeScreen();
                                  },
                                ),
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
                                          return const SettingsScreen();
                                        },
                                      );
                                    }),
                              ]
                            : [
                                NeumorphicIconButton(
                                  icon: Icon(
                                    Icons.emergency_share,
                                    color: Colors.red[400],
                                    size: 40.sp,
                                  ),
                                  onPressed: () async {
                                    await showReportScreen(
                                      context: context,
                                      user: user,
                                    );
                                  },
                                ),
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
                              ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Neumorphic(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  style: commonNeumorphic(depth: 1.6),
                  child: DataTable(
                      columnSpacing: 83,
                      headingRowHeight: 0,
                      border: const TableBorder(top: BorderSide.none),
                      // dataRowHeight: double.parse('20'),
                      columns: [
                        DataColumn(
                          label: Container(
                            width: 35.w,
                          ),
                        ),
                        DataColumn(
                          label: Container(),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text(
                              '1ヶ月間の通報回数',
                              style: TextStyle(fontSize: 9.sp),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 100,
                              child: Text('${controller.reportedCount} 回'),
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text("開始日")),
                          DataCell(Text(controller.createdAtOnFormat)),
                        ]),
                      ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
