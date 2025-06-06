import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/post_add/add_post_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/neumorphic_style.dart';
import '../../widget/common_showcase.dart';

class AddPostScreen extends LoadingGetView<AddPostController> {
  static const routeName = '/AddPost';
  @override
  AddPostController get ctr => AddPostController();

  @override
  bool get enableTap => false;

  @override
  Widget get child {
    return ShowCaseWidget(
      builder: (context) {
        return Scaffold(
          backgroundColor: ConstsColor.mainBackColor,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("投稿"),
                NeumorphicIconButton(
                  icon: const Icon(Icons.description),
                  onPressed: () {
                    controller.showTutorial(context);
                  },
                ),
              ],
            ),
            actions: [
              Obx(
                () => commonShowcaseWidget(
                  key: controller.tutorialKey3,
                  description: "このボタンで投稿します。",
                  color: ConstsColor.mainGreenColor!.withValues(alpha: 0.4),
                  child: NeumorphicIconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: controller.canSend.value
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialog(
                                  title: "Need Address",
                                  descripon: "Contain Your Address this Post",
                                  icon: Icons.home,
                                  mainColor: Colors.pink,
                                  onPress: () {
                                    controller.sendPost();
                                  },
                                );
                              },
                            );
                          }
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CircleImageButton(
                        imageProvider: getUserImage(
                          AuthService.to.currentUser.value!,
                        ),
                        size: 40.sp,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 80.w),
                      child: AutoSizeTextField(
                        controller: controller.tX,
                        autofocus: true,
                        cursorColor: Colors.black,
                        maxLines: 10,
                        // maxLength: 200,
                        style: const TextStyle(fontSize: 17),
                        decoration: const InputDecoration(
                          hintText: "You Doing",
                          focusColor: Colors.black,
                          border: null,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        onChanged: controller.streamText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomSheet: const AbovePostField(),
        );
      },
    );
  }
}

class AbovePostField extends GetView<AddPostController> {
  const AbovePostField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstsColor.mainBackColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          commonShowcaseWidget(
            key: controller.tutorialKey2,
            description: "投稿が自動で削除される時間を設定できます。",
            color: ConstsColor.mainGreenColor!.withValues(alpha: 0.4),
            child: Container(
              height: 10.h,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: ExpireTime.values.length,
                itemBuilder: (context, index) {
                  final expire = ExpireTime.values[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => NeumorphicRadio(
                            style: commonRatioStyle(
                              selectedColor: ConstsColor.mainGreenColor,
                            ),
                            padding: const EdgeInsets.all(12),
                            value: expire,
                            groupValue: controller.expireTime.value,
                            onChanged: (ExpireTime? expire) {
                              if (expire != null) {
                                controller.expireTime.call(expire);
                              }
                            },
                          ),
                        ),
                        Text(
                          "${expire.title} に削除",
                          style: TextStyle(fontSize: 7.sp),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          commonShowcaseWidget(
            key: controller.tutorialKey1,
            description: "緊急度をスライダー形式で設定できます。",
            color: ConstsColor.mainGreenColor!.withValues(alpha: 0.4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomSlider(rxValue: controller.emergencyValue),
                IgnorePointer(
                  child: Obx(
                    () => Text(
                      "緊急度 ${controller.emergency.value} %",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // showcase のpositionを変更するため
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
