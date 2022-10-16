import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ConstsColor {
  static final mainBackColor = Colors.grey[400]!;
  static const cautionColor = Colors.yellow;
  static final mianPinkColor = hexToColor("#ffccd6");
  static final mainGreenColor = Colors.green[300];
  static final locationColor = hexToColor("ff05d56");
  static const mainOrangeColor = Color.fromARGB(255, 249, 154, 38);
}

// static final commonBackground = Colors.grey[200];

