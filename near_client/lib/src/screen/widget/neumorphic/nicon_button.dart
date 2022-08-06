import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';

import '../../../utils/consts_color.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    Key? key,
    required this.icon,
    this.color,
    this.depth,
    this.onPressed,
    this.boxShape,
  }) : super(key: key);

  final Widget icon;

  final Color? color;

  final double? depth;
  final NeumorphicBoxShape? boxShape;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: boxShape ?? NeumorphicBoxShape.circle(),
        color: color ?? ConstsColor.mainBackColor,
        depth: depth ?? 1,
        intensity: 2,
      ),
      child: icon,
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
          color: ConstsColor.mainBackColor,
          shadowLightColor: Colors.black45
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
