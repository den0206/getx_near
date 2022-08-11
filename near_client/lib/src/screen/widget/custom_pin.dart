import 'package:flutter/material.dart';

import '../../utils/validator.dart';

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
