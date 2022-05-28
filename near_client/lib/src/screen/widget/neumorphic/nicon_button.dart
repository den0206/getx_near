import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../utils/consts_color.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({Key? key, required this.iconData, this.onPressed})
      : super(key: key);

  final IconData iconData;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: ConstsColor.panelColor,
      ),
      child: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
