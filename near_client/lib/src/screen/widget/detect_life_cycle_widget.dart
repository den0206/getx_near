import 'package:flutter/material.dart';

class DetectLifeCycleWidget extends StatefulWidget {
  const DetectLifeCycleWidget({
    Key? key,
    required this.child,
    required this.onChangeState,
  }) : super(key: key);

  final Widget child;
  final Function(AppLifecycleState state) onChangeState;

  @override
  DetectLifeCycleWidgetState createState() => DetectLifeCycleWidgetState();
}

class DetectLifeCycleWidgetState extends State<DetectLifeCycleWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      widget.onChangeState.call(state);

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
