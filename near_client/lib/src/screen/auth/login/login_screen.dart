import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/auth/login/login_controller.dart';
import 'package:getx_near/src/screen/widget/animation_widget.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        return VisibilityDetector(
          key: const Key("Login"),
          onVisibilityChanged: (visibilityInfo) {
            var visiblePercentage = visibilityInfo.visibleFraction * 100;
            if (visiblePercentage == 100) {
              // 初回起動時のみ
              if (!controller.acceptTerms) showTermsDialog(context);
            }
          },
          child: GestureDetector(
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
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: controller.passwordController,
                        labelText: "Password",
                        isSecure: true,
                        iconData: Icons.lock,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: NeumorphicTextButton(
                          title: "Forgot Password",
                          onPressed: () async {
                            await controller.showResetPassword();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => CustomButton(
                          title: "Login",
                          background: ConstsColor.mainGreenColor,
                          onPressed: controller.buttonEnale.value
                              ? () async {
                                  await controller.login();
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      NeumorphicTextButton(
                        title: "Sign Up",
                        onPressed: () {
                          controller.showSignUpScreen();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showTermsDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return PopScope(
        canPop: false,
        child: GetBuilder<LoginController>(
          builder: (current) {
            return FadeinWidget(
              child: Center(
                child: Container(
                  width: 85.w,
                  height: MediaQuery.of(context).size.height - 80,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ConstsColor.mainBackColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: FutureBuilder(
                          future: rootBundle.loadString(
                            "assets/markdown/privacy_jpn.md",
                          ),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Markdown(
                                data: snapshot.data!,
                                shrinkWrap: true,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Material(
                          color: ConstsColor.mainBackColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                value: current.acceptTerms,
                                onChanged: (value) {
                                  if (value == null) return;
                                  current.acceptTerms = value;
                                  current.update();
                                },
                              ),
                              const Text(
                                '利用規約に同意します',
                                style: TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomButton(
                        title: "OK",
                        background: Colors.green,
                        onPressed: !current.acceptTerms
                            ? null
                            : () {
                                current.setTerms(context);
                              },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
