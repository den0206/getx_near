import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dismisskeyBord(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void showSnackBar({required String title}) {
  Get.snackbar(
    title,
    "Please Login",
    icon: Icon(Icons.person, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    borderRadius: 20,
    margin: EdgeInsets.all(15),
    colorText: Colors.white,
    duration: Duration(seconds: 4),
    isDismissible: true,
    dismissDirection: DismissDirection.down,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
