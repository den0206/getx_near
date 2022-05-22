import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/auth/login/login_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';

class LoginScreen extends LoadingGetView<LoginController> {
  static const routeName = '/LoginScreen';
  @override
  LoginController get ctr => LoginController();

  @override
  Widget get child {
    return Scaffold(
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
              Builder(
                builder: (context) {
                  return CustomButton(
                    title: "Login",
                    onPressed: controller.buttonEnale.value
                        ? () {
                            controller.login();
                          }
                        : null,
                  );
                },
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
    );
  }
}
