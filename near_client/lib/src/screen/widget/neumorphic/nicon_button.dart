import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';

import '../../../model/user.dart';
import '../../../utils/consts_color.dart';

class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.color,
    this.size,
    this.depth,
    this.onPressed,
    this.boxShape,
  });

  final Widget icon;

  final Color? color;
  final double? size;
  final double? depth;
  final NeumorphicBoxShape? boxShape;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.all(10),
      style: NeumorphicStyle(
        boxShape: boxShape ?? const NeumorphicBoxShape.circle(),
        color: color ?? ConstsColor.mainBackColor,
        depth: depth ?? 1,
        intensity: 2,
      ),
      onPressed: onPressed,
      child: icon,
    );
  }
}

class UserAvatarButton extends StatelessWidget {
  const UserAvatarButton({
    super.key,
    required this.user,
    this.size = 120,
    this.useNeumorphic = true,
    this.useSex = true,
    this.onTap,
  });
  final User user;
  final double size;
  final bool useNeumorphic;
  final bool useSex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (useNeumorphic)
          NeumorphicAvatarButton(
            imageProvider: getUserImage(user),
            size: size,
            onTap: onTap,
          ),
        if (!useNeumorphic)
          CircleImageButton(
            imageProvider: getUserImage(user),
            size: size,
            onTap: onTap,
          ),
        if (useSex)
          SexButton(
            user: user,
            size: size / 2,
          )
      ],
    );
  }
}

class SexButton extends StatelessWidget {
  const SexButton({
    super.key,
    required this.user,
    required this.size,
  });

  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(color: user.sex.mainColor, shape: BoxShape.circle),
      child: Icon(
        user.sex.icon,
        size: size / 2,
      ),
    );
  }
}

class NeumorphicAvatarButton extends StatelessWidget {
  const NeumorphicAvatarButton({
    super.key,
    required this.imageProvider,
    required this.size,
    this.onTap,
  });

  final ImageProvider<Object> imageProvider;
  final double size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: const EdgeInsets.all(10),
      style: NeumorphicStyle(
          boxShape: const NeumorphicBoxShape.circle(),
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

class NeumorphicTextButton extends StatelessWidget {
  const NeumorphicTextButton({
    super.key,
    required this.title,
    this.titleColor = Colors.green,
    this.onPressed,
  });

  final String title;
  final Color titleColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: NeumorphicText(
        title,
        style: NeumorphicStyle(
          intensity: 1,
          depth: 1,
          color: titleColor,
          surfaceIntensity: 2,
        ),
        textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
