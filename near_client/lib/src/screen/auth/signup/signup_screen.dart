import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/auth/signup/signup_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_pin.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/neumorphic_style.dart';
import 'package:getx_near/src/utils/validator.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends LoadingGetView<SignUpController> {
  static const routeName = '/SignUpScreen';
  @override
  SignUpController get ctr => SignUpController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUpState');

  @override
  Widget get child {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (controller.state == VerifyState.checkEmail) ...[
                        Builder(
                          builder: (context) {
                            return NeumorphicAvatarButton(
                              imageProvider: controller.userImage == null
                                  ? Image.asset(
                                      "assets/images/default_user.png",
                                    ).image
                                  : FileImage(controller.userImage!),
                              size: 120,
                              onTap: () {
                                controller.selectImage(context);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: controller.nameController,
                          labelText: "name",
                          iconData: Icons.person,
                          validator: valideName,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.emailController,
                          labelText: "email",
                          iconData: Icons.email,
                          validator: validateEmail,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: controller.passwordController,
                          labelText: "Password",
                          iconData: Icons.lock,
                          validator: validPassword,
                          isSecure: true,
                        ),
                        const SizedBox(height: 25),
                        NeumorphicToggle(
                          style: NeumorphicToggleStyle(
                            depth: -2,
                            backgroundColor: ConstsColor.mainBackColor,
                          ),
                          height: 50,
                          selectedIndex: controller.sexIndex,
                          displayForegroundOnlyIfSelected: true,
                          children: Sex.values
                              .map(
                                (sex) => ToggleElement(
                                  background: Center(
                                    child: Text(
                                      sex.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  foreground: Center(
                                    child: Text(
                                      sex.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          thumb: Neumorphic(style: commonNeumorphic()),
                          onChanged: controller.changeSex,
                        ),
                      ],
                      if (controller.state == VerifyState.verify) ...[
                        CustomPinCodeField(
                          controller: controller.pinCodeController,
                          inputType: controller.state.inputType,
                          isSecure: true,
                        ),
                      ],
                      SizedBox(height: 3.h),
                      CustomButton(
                        title: "Sign Up",
                        background: ConstsColor.mainGreenColor,
                        onPressed: controller.buttonEnable
                            ? () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  controller.signUp();
                                }
                              }
                            : null,
                      ),
                      Builder(
                        builder: (context) {
                          return NeumorphicTextButton(
                            title: "Alredy Have",
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
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
