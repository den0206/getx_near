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

Showcase CommonShowcaseWidget(
    {required GlobalKey key,
    required String description,
    required Widget child,
    Color? color}) {
  return Showcase.withWidget(
    key: key,
    container: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: Text(
        description,
        style: TextStyle(color: Colors.white),
      ),
    ),
    height: 50.h,
    width: 70.w,
    overlayColor: color ?? Colors.black45,
    radius: BorderRadius.all(Radius.circular(40)),
    tipBorderRadius: BorderRadius.all(Radius.circular(8)),
    child: child,
  );
}
