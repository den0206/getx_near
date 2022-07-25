import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ConstsColor {
  static final panelColor = hexToColor("#ffccd6");
  static final cautionColor = Colors.yellow;

  static final mainGreenColor = Colors.green[300];
}

// static final commonBackground = Colors.grey[200];
// static final panelColor = Colors.grey[400]!;
