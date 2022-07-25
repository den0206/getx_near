import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'consts_color.dart';

NeumorphicStyle commonNeumorphic(
    {NeumorphicBoxShape? boxShape,
    double? depth,
    Color? color,
    Color? shadowColor,
    Color? shadowLightColorEmboss,
    LightSource? lightSource}) {
  return NeumorphicStyle(
    shape: NeumorphicShape.concave,
    boxShape:
        boxShape ?? NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
    depth: depth ?? 10,
    lightSource: lightSource ?? LightSource.topLeft,
    color: color ?? ConstsColor.panelColor,
    shadowLightColor: shadowColor,
    shadowLightColorEmboss: shadowLightColorEmboss,
    intensity: 1,
  );
}

NeumorphicRadioStyle commonRatioStyle({Color? selectedColor}) {
  return NeumorphicRadioStyle(
    selectedColor: selectedColor,
    unselectedColor: ConstsColor.panelColor,
    intensity: 1,
    selectedDepth: -5,
    unselectedDepth: 5,
    boxShape: NeumorphicBoxShape.circle(),
  );
}
