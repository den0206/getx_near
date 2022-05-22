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
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

class AddPostScreen extends LoadingGetView<AddPostController> {
  static const routeName = '/AddPost';
  @override
  AddPostController get ctr => AddPostController();

  @override
  bool get enableTap => false;

  @override
  Widget get child {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: ConstsColor.panelColor,
        appBar: AppBar(
          title: Text("投稿"),
          actions: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
                child: MaterialButton(
                  elevation: 2,
                  color: ConstsColor.panelColor,
                  textColor: Colors.white,
                  child: Text("Send"),
                  shape: StadiumBorder(),
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
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CircleImageButton(
                      imageProvider:
                          getUserImage(AuthService.to.currentUser.value!),
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
                      style: TextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: "You Doing",
                        focusColor: Colors.black,
                        border: null,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      onChanged: controller.streamText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomSheet: AbovePostField(),
      );
    });
  }
}

class AbovePostField extends GetView<AddPostController> {
  const AbovePostField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ConstsColor.panelColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10.h,
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                      Obx(() => NeumorphicRadio(
                            style: NeumorphicRadioStyle(
                              selectedColor: Colors.green,
                              unselectedColor: Colors.transparent,
                              intensity: 2,
                              selectedDepth: -5,
                              unselectedDepth: 5,
                              boxShape: NeumorphicBoxShape.circle(),
                              // border: controller.expireTime.value != expire
                              //     ? NeumorphicBorder(color: Colors.white)
                              //     : NeumorphicBorder.none(),
                            ),
                            child: Text(""),
                            // Container(
                            //   width: 20,
                            //   height: 20,
                            // ),
                            padding: EdgeInsets.all(12),
                            value: expire,
                            groupValue: controller.expireTime.value,
                            onChanged: (ExpireTime? expire) {
                              if (expire != null)
                                controller.expireTime.call(expire);
                            },
                          )),
                      Text(
                        "${expire.title} に削除",
                        style: TextStyle(fontSize: 7.sp),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CustomSlider(
                rxValue: controller.emergencyValue,
              ),
              IgnorePointer(
                child: Obx(
                  () => Text(
                    "緊急度 ${controller.emergency.value} %",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
