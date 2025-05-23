import 'package:flutter/material.dart';

class BlinkingWidet extends StatefulWidget {
  const BlinkingWidet({
    super.key,
    required this.child,
    required this.duration,
    this.use = true,
  });
  final Widget child;
  final Duration duration;
  final bool use;

  @override
  State<BlinkingWidet> createState() => _BlinkingWidetState();
}

class _BlinkingWidetState extends State<BlinkingWidet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.use
        ? FadeTransition(opacity: _animationController, child: widget.child)
        : widget.child;
  }
}
