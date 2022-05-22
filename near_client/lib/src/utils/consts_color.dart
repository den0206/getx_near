import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ConstsColor {
  static final commonBackground = Colors.grey[200];
  static final panelColor = Colors.grey[400]!;
  static final cautionColor = Colors.yellow;
}

final commonNeumorphic = NeumorphicStyle(
  shape: NeumorphicShape.concave,
  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
  depth: 10,
  lightSource: LightSource.topLeft,
  color: ConstsColor.panelColor,
);
