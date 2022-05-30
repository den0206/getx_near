import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';

import '../../../utils/consts_color.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    Key? key,
    required this.iconData,
    this.color,
    this.iconColor,
    this.onPressed,
  }) : super(key: key);

  final IconData iconData;
  final Color? iconColor;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          color: color ?? ConstsColor.panelColor,
          depth: 0.6),
      child: Icon(
        iconData,
        color: iconColor,
      ),
      onPressed: onPressed,
    );
  }
}

class NeumorphicAvatarButton extends StatelessWidget {
  const NeumorphicAvatarButton({
    Key? key,
    required this.imageProvider,
    this.size = 120,
    this.onTap,
  }) : super(key: key);

  final ImageProvider<Object> imageProvider;
  final double size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: ConstsColor.panelColor,
        // depth: NeumorphicTheme.embossDepth(context),
      ),
      child: CircleImageButton(
        imageProvider: imageProvider,
        size: size,
        onTap: onTap,
      ),
    );
  }
}
