import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/consts_color.dart';

class NeoPressButton extends StatefulWidget {
  NeoPressButton({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<NeoPressButton> createState() => _NeoPressButtonState();
}

class _NeoPressButtonState extends State<NeoPressButton> {
  bool isPressing = false;

  @override
  Widget build(BuildContext context) {
    Offset distance = isPressing ? Offset(10, 10) : Offset(8, 8);
    double blur = isPressing ? 5 : 10;

    return Listener(
      onPointerDown: (_) {
        setState(() {
          isPressing = true;
        });
      },
      onPointerUp: (_) {
        setState(() {
          isPressing = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        decoration: BoxDecoration(
            color: ConstsColor.panelColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isPressing ? Color(0xFFA7A9AF) : Colors.white24,
                offset: -distance,
                blurRadius: blur,
                spreadRadius: 5.0,
                inset: isPressing,
              ),
              BoxShadow(
                color: Color(0xFFA7A9AF),
                offset: distance,
                blurRadius: blur,
                // spreadRadius: 2.0,
                inset: isPressing,
              ),
            ]),
        child: SizedBox(
          height: 66.h,
          width: 70.w,
          child: widget.child,
        ),
      ),
    );
  }
}
