import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/screen/users/protect_home/protect_home_controller.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../../../service/location_service.dart';

class ProtectHomeScreen extends StatelessWidget {
  static const routeName = '/ProtectHome';
  const ProtectHomeScreen({super.key, this.isTutorial = false});

  final bool isTutorial;

  @override
  Widget build(BuildContext context) {
    final _markDownData = [
      "家周辺にいる場合,投稿を禁止にできます ",
      "当情報は外部サーバーに送信されません。",
      "暗号化して端末に保持されます。",
      "位置情報の正確度は設定より変更できます。",
      "当ページから迅速に削除・更新が可能です。",
    ].map((x) => "- $x\n").reduce((x, y) => "$x$y");

    return Scaffold(
      backgroundColor: isTutorial ? Colors.transparent : null,
      appBar: AppBar(
        title: const Text('家周辺の登録'),
        automaticallyImplyLeading: !isTutorial,
      ),
      body: GetBuilder<ProtectHomeController>(
        init: ProtectHomeController(),
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Markdown(data: _markDownData, shrinkWrap: true),
              Text(
                controller.currentUser.hasHome && controller.address != null
                    ? "${controller.address} 周辺"
                    : "未登録です",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              NeumorphicIconButton(
                depth: !controller.currentUser.hasHome ? 1 : -1,
                icon: Icon(
                  Icons.home,
                  size: 100.sp,
                  color: !controller.currentUser.hasHome
                      ? ConstsColor.locationColor
                      : ConstsColor.mainGreenColor,
                ),
                onPressed: () async {
                  await controller.tryRegisterHome(context);
                },
              ),
              if (controller.currentUser.hasHome)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: NeumorphicTextButton(
                      title: "居住地の削除",
                      titleColor: ConstsColor.locationColor,
                      onPressed: () async {
                        await controller.tryDeleteHome(context);
                      },
                    ),
                  ),
                ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text("投稿禁止範囲"),
                          Text(
                            "${controller.homeDistance} m",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      NeumorphicSlider(
                        min: kMinDistance.toDouble(),
                        max: kMaxDistance.toDouble(),
                        value: controller.currentDistance.value,
                        style: SliderStyle(
                          variant: ConstsColor.mainBackColor,
                          accent: controller.currentUser.sex.mainColor,
                          depth: 1,
                        ),
                        sliderHeight: 30,
                        onChanged: (percent) {
                          controller.currentDistance.value = percent;
                        },
                        onChangeEnd: (percent) async {
                          await controller.setHomeDistance();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          );
        },
      ),
    );
  }
}
