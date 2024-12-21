import 'package:flutter/material.dart';

class HelpAnimatedWidet extends StatefulWidget {
  const HelpAnimatedWidet({super.key});

  @override
  State<HelpAnimatedWidet> createState() => _HelpAnimatedWidetState();
}

class _HelpAnimatedWidetState extends State<HelpAnimatedWidet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimatoin;

  bool showImage = false;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.4).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    scaleAnimatoin =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      if (scaleAnimatoin.value > 0.15) {
        setState(() {
          showImage = true;
        });
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: opacityAnimation.value),
      child: Center(
          child: ScaleTransition(
        scale: scaleAnimatoin,
        child: Visibility(
          visible: showImage,
          child: FadeinOutWidget(
              child: Image.asset("assets/images/icon-remove_background.png")),
        ),
      )),
    );
  }
}

class FadeinWidget extends StatefulWidget {
  const FadeinWidget({super.key, required this.child, this.duration});

  final Widget child;
  final Duration? duration;

  @override
  State<FadeinWidget> createState() => _FadeinWidgetState();
}

class _FadeinWidgetState extends State<FadeinWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1000),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.stop();
      }
    });
  }

  @override
  void dispose() {
    animation.removeStatusListener((status) {});
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }
}

class FadeinOutWidget extends StatefulWidget {
  const FadeinOutWidget({super.key, required this.child, this.duration});

  final Widget child;
  final Duration? duration;

  @override
  State<FadeinOutWidget> createState() => _FadeinOutWidgetState();
}

class _FadeinOutWidgetState extends State<FadeinOutWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 600),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward();

    animation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // await Future.delayed(Duration(milliseconds: 300));
        controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animation.removeStatusListener((status) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: widget.child,
    );
  }
}
