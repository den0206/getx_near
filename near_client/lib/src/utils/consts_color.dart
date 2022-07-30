import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ConstsColor {
  static final mainBackColor = Colors.grey[400]!;
  static final cautionColor = Colors.yellow;
  static final mianPinkColor = hexToColor("#ffccd6");
  static final mainGreenColor = Colors.green[300];
}

// static final commonBackground = Colors.grey[200];

