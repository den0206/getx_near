import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class GetSizeWidget extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const GetSizeWidget({super.key, required this.onChange, required this.child});

  @override
  _GetSizeWidgetState createState() => _GetSizeWidgetState();
}

class _GetSizeWidgetState extends State<GetSizeWidget> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(key: widgetKey, child: widget.child);
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
