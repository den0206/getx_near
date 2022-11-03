import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

class CommonShowCase {
  CommonShowCase(this.widgetIds);

  final List<GlobalKey<State<StatefulWidget>>> widgetIds;

  void showTutorial(BuildContext context) {
    ShowCaseWidget.of(context).startShowCase(widgetIds);
  }
}

Showcase commonShowcaseWidget(
    {required GlobalKey key,
    required String description,
    required Widget child,
    Color? color}) {
  return Showcase.withWidget(
    key: key,
    container: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: Text(
        description,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    height: 50.h,
    width: 70.w,
    overlayColor: color ?? Colors.black45,
    radius: const BorderRadius.all(Radius.circular(40)),
    tipBorderRadius: const BorderRadius.all(Radius.circular(8)),
    child: child,
  );
}
