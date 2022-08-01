import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/auth/login/login_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/global_functions.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            dismisskeyBord(context);
          },
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: controller.emailController,
                      labelText: "Email",
                      iconData: Icons.email,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      controller: controller.passwordController,
                      labelText: "Password",
                      isSecure: true,
                      iconData: Icons.lock,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text("Forgot Password"),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => CustomButton(
                        title: "Login",
                        background: ConstsColor.mainGreenColor,
                        onPressed: controller.buttonEnale.value
                            ? () {
                                controller.login();
                              }
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: Text("Sign Up"),
                      onPressed: () {
                        controller.showSignUpScreen();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
