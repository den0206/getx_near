import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:getx_near/src/screen/users/user_edit/user_edit_controller.dart';
import '../../../model/user.dart';
import '../../../utils/consts_color.dart';
import '../../../utils/neumorphic_style.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/loading_widget.dart';
import '../../widget/neumorphic/nicon_button.dart';
import 'package:sizer/sizer.dart';

class UserEditScreen extends LoadingGetView<UserEditController> {
  static const routeName = '/EditScreen';
  @override
  UserEditController get ctr => UserEditController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Text("編集"),
      ),
      body: Neumorphic(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        style: commonNeumorphic(depth: 1.6),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Builder(builder: (context) {
                  return Obx(() => NeumorphicAvatarButton(
                        imageProvider: controller.userImage.value == null
                            ? getUserImage(controller.currentUser)
                            : FileImage(controller.userImage.value!),
                        onTap: () {
                          controller.selectImage(context);
                        },
                      ));
                }),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: controller.nameController,
                    labelText: "name",
                    iconData: Icons.person,
                    onChange: (text) {
                      controller.editUser.name = text;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text(
                      "Change Email",
                    ),
                    onPressed: () {},
                  ),
                ),
                Obx(
                  () => CustomButton(
                    title: "Edit",
                    width: 50.w,
                    background: ConstsColor.mainGreenColor,
                    onPressed: controller.isChanged.value
                        ? () {
                            controller.updateUser();
                          }
                        : null,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Builder(builder: (context) {
                  return CustomButton(
                    title: "Delete",
                    width: 50.w,
                    background: Colors.red,
                    onPressed: () {},
                  );
                }),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
