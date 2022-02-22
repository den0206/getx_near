import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

enum AlertLevel { safe, easy, medium, strong, emergency }

extension AlertLevelEXT on AlertLevel {
  Color get mainColor {
    switch (this) {
      case AlertLevel.safe:
        return Colors.blue;
      case AlertLevel.easy:
        return Colors.green;
      case AlertLevel.medium:
        return Colors.orange;
      case AlertLevel.strong:
        return Colors.red;
      case AlertLevel.emergency:
        return Colors.purple;
    }
  }
}

AlertLevel getAlert(double current) {
  if (current < 20) {
    return AlertLevel.safe;
  } else if (current >= 20 && current < 50) {
    return AlertLevel.easy;
  } else if (current >= 50 && current < 70) {
    return AlertLevel.medium;
  } else if (current >= 70 && current < 90) {
    return AlertLevel.strong;
  } else {
    return AlertLevel.emergency;
  }
}

class AlertIndicator extends StatelessWidget {
  const AlertIndicator({Key? key, required this.intValue, required this.level})
      : super(key: key);

  final int intValue;
  final AlertLevel level;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: intValue / 100,
              valueColor: AlwaysStoppedAnimation<Color>(level.mainColor),
              backgroundColor: Color(0xffD6D6D6),
            ),
          ),
        ),
        Text(
          "${intValue} %",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            // color: Colors.black54,
            fontSize: 15.sp,
          ),
        )
      ],
    );
  }
}

class HelpButton extends StatelessWidget {
  const HelpButton({
    Key? key,
    required this.post,
    required this.size,
    this.uselabel = false,
  }) : super(key: key);

  final Post post;
  final double size;
  final bool uselabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning_amber,
          color: ConstsColor.cautionColor,
          size: size,
        ),
        if (uselabel)
          Text(
            "Want Help!",
            style: TextStyle(color: ConstsColor.cautionColor),
          ),
        Text(
          "${10}",
          style: TextStyle(
            color: ConstsColor.cautionColor,
          ),
        )
      ],
    );
  }
}

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    Key? key,
    required this.rxValue,
    this.trackHeight = 30,
  }) : super(key: key);

  final RxDouble rxValue;
  final double trackHeight;

  @override
  Widget build(BuildContext context) {
    AlertLevel level = getAlert(rxValue.value);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
            // activeTrackColor: Colors.green,
            trackHeight: trackHeight,
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: trackHeight / 2,
                disabledThumbRadius: 5,
                elevation: 0),
            trackShape: RoundSliderTrackShape()),
        child: Obx(() => Slider(
              value: rxValue.value,
              min: 0,
              max: 100.0,
              activeColor: level.mainColor,
              inactiveColor: Color(0xFF8D8E98),
              onChanged: (double newValue) {
                level = getAlert(newValue);
                rxValue.call(newValue);
              },
            )),
      ),
    );
  }
}

class RoundSliderTrackShape extends SliderTrackShape {
  const RoundSliderTrackShape({this.disabledThumbGapWidth = 2.0});

  final double disabledThumbGapWidth;

  @override
  Rect getPreferredRect(
      {required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool? isEnabled,
      bool? isDiscrete}) {
    final double overlayWidth = sliderTheme.overlayShape!
        .getPreferredSize(isEnabled ?? true, isDiscrete ?? true)
        .width;

    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= overlayWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;

    final double trackWidth = parentBox.size.width - overlayWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      bool? isEnabled,
      bool? isDiscrete,
      required TextDirection textDirection}) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    double horizontalAdjustment = 0.0;
    if (isEnabled != null && !isEnabled) {
      final double disabledThumbRadius =
          sliderTheme.thumbShape!.getPreferredSize(false, isDiscrete!).width /
              2.0;
      final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
      horizontalAdjustment = disabledThumbRadius + gap;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top,
        thumbCenter.dx - horizontalAdjustment, trackRect.bottom);

    final th = sliderTheme.trackHeight! * 1 / 2;

// Left Arc

    context.canvas.drawArc(
        Rect.fromCircle(
            center: Offset(trackRect.left, trackRect.top + th), radius: th),
        -pi * 3 / 2, // -270 degrees
        pi, // 180 degrees
        false,
        trackRect.left - thumbCenter.dx == 0.0
            ? rightTrackPaint
            : leftTrackPaint);

// Right Arc

    context.canvas.drawArc(
        Rect.fromCircle(
            center: Offset(trackRect.right, trackRect.top + th), radius: th),
        -pi / 2, // -90 degrees
        pi, // 180 degrees
        false,
        trackRect.right - thumbCenter.dx == 0.0
            ? leftTrackPaint
            : rightTrackPaint);

    context.canvas.drawRect(leftTrackSegment, leftTrackPaint);
    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx + horizontalAdjustment,
        trackRect.top,
        trackRect.right,
        trackRect.bottom);
    context.canvas.drawRect(rightTrackSegment, rightTrackPaint);
  }
}
