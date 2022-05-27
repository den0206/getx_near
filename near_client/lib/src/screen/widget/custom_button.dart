import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../../utils/neumorphic_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    this.titleColor = Colors.black,
    this.width = 250,
    this.height = 60,
    this.isLoading = false,
    this.background,
    this.shadowColor = Colors.white,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color titleColor;
  final Color? background;
  final double width;
  final double height;
  final Color shadowColor;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: NeumorphicButton(
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: onPressed,
        style: commonNeumorphic(
          color: background ?? ConstsColor.panelColor,
          lightSource: LightSource.bottomLeft,
          shadowColor: shadowColor,
        ),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    Key? key,
    required this.imageProvider,
    required this.size,
    this.addShadow = true,
    this.fit = BoxFit.cover,
    this.border,
    this.onTap,
  }) : super(key: key);

  final ImageProvider imageProvider;
  final double size;
  final bool addShadow;
  final Border? border;
  final BoxFit fit;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          image: DecorationImage(image: imageProvider, fit: fit),
          border: border == null
              ? Border.all(color: Colors.grey, width: 1)
              : border,
          boxShadow: addShadow
              ? [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 15.0,
                    color: Colors.white,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
