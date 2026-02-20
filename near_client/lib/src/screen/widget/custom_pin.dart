import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/validator.dart';
import 'custom_textfield.dart';

enum VerifyState {
  checkEmail,
  sendPassword,
  verify;

  String get title {
    switch (this) {
      case VerifyState.checkEmail:
        return "Check Email";
      case VerifyState.sendPassword:
        return "Send Password";
      case VerifyState.verify:
        return "Verify Number";
    }
  }

  TextInputType get inputType {
    switch (this) {
      case VerifyState.checkEmail:
        return TextInputType.emailAddress;
      case VerifyState.sendPassword:
        return TextInputType.visiblePassword;
      case VerifyState.verify:
        return TextInputType.number;
    }
  }

  bool get isSecure {
    return this != VerifyState.checkEmail;
  }

  int get minLength {
    switch (this) {
      case VerifyState.checkEmail:
        return 1;
      case VerifyState.sendPassword:
        return 5;
      case VerifyState.verify:
        return 6;
    }
  }

  String? validator(String? value) {
    switch (this) {
      case VerifyState.checkEmail:
        return validateEmail(value);
      case VerifyState.sendPassword:
        return validPassword(value);
      case VerifyState.verify:
        return null;
    }
  }

  String get buttonTitle {
    switch (this) {
      case VerifyState.checkEmail:
      case VerifyState.sendPassword:
        return "Sign UP";
      case VerifyState.verify:
        return "Verify Number";
    }
  }
}

class CustomPinCodeField extends StatefulWidget {
  const CustomPinCodeField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.isSecure,
    this.onChange,
  });

  final TextEditingController controller;
  final TextInputType inputType;
  final bool isSecure;
  final Function(String text)? onChange;

  @override
  State<CustomPinCodeField> createState() => _CustomPinCodeFieldState();
}

class _CustomPinCodeFieldState extends State<CustomPinCodeField> {
  late final PinInputController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = PinInputController();
    if (widget.controller.text.isNotEmpty) {
      _pinController.setText(widget.controller.text);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      pinController: _pinController,
      length: 6,
      autoFocus: true,
      obscureText: widget.isSecure,
      blinkWhenObscuring: true,
      keyboardType: widget.inputType,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        borderRadius: BorderRadius.circular(5),
        cellSize: const Size(40, 50),
        borderColor: Colors.grey,
        focusedBorderColor: Colors.grey,
        filledBorderColor: Colors.grey,
        cursorColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        entryAnimation: MaterialPinAnimation.fade,
      ),
      onChanged: (value) {
        widget.controller.text = value;
        widget.onChange?.call(value);
      },
      enablePaste: true,
      clipboardValidator: (text, length) {
        debugPrint("Allowing to paste $text");
        return true;
      },
    );
  }
}

class PinCodeArea extends StatelessWidget {
  const PinCodeArea({
    super.key,
    required this.currentState,
    required this.currentTX,
    this.onChange,
    this.onPressed,
  });

  final VerifyState currentState;
  final TextEditingController currentTX;
  final Function(String)? onChange;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentState == VerifyState.verify)
            const Text(
              "Please Check Your Email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                if (currentState != VerifyState.verify)
                  CustomTextField(
                    controller: currentTX,
                    iconData: Icons.email,
                    labelText: currentState.title,
                    inputType: currentState.inputType,
                    isSecure: currentState.isSecure,
                    validator: currentState.validator,
                    onChange: onChange,
                  ),
                if (currentState == VerifyState.verify)
                  CustomPinCodeField(
                    controller: currentTX,
                    inputType: currentState.inputType,
                    isSecure: currentState.isSecure,
                    onChange: onChange,
                  ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              return CustomButton(
                title: currentState.title,
                background: Colors.green,
                titleColor: Colors.white,
                onPressed: onPressed,
              );
            },
          ),
        ],
      ),
    );
  }
}
