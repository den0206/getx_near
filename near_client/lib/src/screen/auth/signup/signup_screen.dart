import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends LoadingGetView<SignUpController> {
  static const routeName = '/SignUpScreen';
  @override
  SignUpController get ctr => SignUpController();

  @override
  Widget get child {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
            body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleImageButton(
                    imageProvider: controller.userImage == null
                        ? Image.asset("assets/images/default_user.png").image
                        : FileImage(controller.userImage!),
                    size: 15.h,
                    onTap: () {
                      controller.selectImage();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: controller.nameController,
                    labelText: "name",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: controller.emailController,
                    labelText: "email",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: controller.passwordController,
                    labelText: "Pasword",
                    isSecure: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    title: "Sign Up",
                    onPressed: controller.buttonEnable.value
                        ? () {
                            controller.signUp();
                          }
                        : null,
                  ),
                  Builder(builder: (context) {
                    return TextButton(
                      child: Text("Alredy Have"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                  })
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
