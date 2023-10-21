import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../../utils/neumorphic_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.titleColor = Colors.black,
    this.width = 250,
    this.height = 60,
    this.isLoading = false,
    this.background,
    this.shadowColor = Colors.white,
    this.onPressed,
  });

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
    return SizedBox(
      height: height,
      width: width,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: commonNeumorphic(
          color: onPressed != null ? background : ConstsColor.mainBackColor,
          lightSource: LightSource.bottomRight,
          depth: 1.2,
          shadowColor: shadowColor,
        ),
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
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    super.key,
    required this.imageProvider,
    required this.size,
    this.addShadow = true,
    this.fit = BoxFit.fill,
    this.border,
    this.onTap,
  });

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
          border: border ?? Border.all(color: Colors.grey, width: 1),
          boxShadow: addShadow
              ? [
                  const BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 15.0,
                    color: Colors.black12,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
