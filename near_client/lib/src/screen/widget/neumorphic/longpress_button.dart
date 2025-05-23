import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// ignore: implementation_imports
import 'package:flutter_neumorphic/src/widget/animation/animated_scale.dart'
    as animationScale;

class LongNeumorphicButton extends StatefulWidget {
  static const double PRESSED_SCALE = 0.98;
  static const double UNPRESSED_SCALE = 1.0;

  final Widget? child;
  final NeumorphicStyle? style;
  final double minDistance;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool? pressed; //null, true, false
  final Duration duration;
  final Curve curve;
  final NeumorphicButtonClickListener? onPressed;
  final NeumorphicButtonClickListener? onEnded;
  final bool drawSurfaceAboveChild;
  final bool provideHapticFeedback;
  final String? tooltip;

  const LongNeumorphicButton({
    super.key,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.child,
    this.tooltip,
    this.drawSurfaceAboveChild = true,
    this.pressed,
    //true/false if you want to change the state of the button
    this.duration = Neumorphic.DEFAULT_DURATION,
    this.curve = Neumorphic.DEFAULT_CURVE,
    //this.accent,
    this.onPressed,
    this.onEnded,
    this.minDistance = 0,
    this.style,
    this.provideHapticFeedback = true,
  });

  bool get isEnabled => onPressed != null && onEnded != null;

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<LongNeumorphicButton> {
  late NeumorphicStyle initialStyle;

  late double depth;
  bool pressed = false; //overwrite widget.pressed when click for animation

  void updateInitialStyle() {
    final appBarPresent = NeumorphicAppBarTheme.of(context) != null;

    final theme = NeumorphicTheme.currentTheme(context);
    initialStyle =
        widget.style ??
        (appBarPresent
            ? theme.appBarTheme.buttonStyle
            : (theme.buttonStyle ?? const NeumorphicStyle()));
    depth =
        widget.style?.depth ??
        (appBarPresent ? theme.appBarTheme.buttonStyle.depth : theme.depth) ??
        0.0;

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateInitialStyle();
  }

  @override
  void didUpdateWidget(LongNeumorphicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateInitialStyle();
  }

  Future<void> _handlePress() async {
    hasFinishedAnimationDown = false;
    setState(() {
      pressed = true;
      depth = widget.minDistance;
    });

    await Future.delayed(widget.duration); //wait until animation finished
    hasFinishedAnimationDown = true;

    //haptic vibration
    if (widget.provideHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    _resetIfTapUp();
  }

  bool hasDisposed = false;

  @override
  void dispose() {
    super.dispose();
    hasDisposed = true;
  }

  //used to stay pressed if no tap up
  void _resetIfTapUp() {
    if (hasFinishedAnimationDown == true && hasTapUp == true && !hasDisposed) {
      setState(() {
        pressed = false;
        depth = initialStyle.depth ?? neumorphicDefaultTheme.depth;

        hasFinishedAnimationDown = false;
        hasTapUp = false;
      });
    }
  }

  bool get clickable {
    return widget.isEnabled &&
        widget.onPressed != null &&
        widget.onEnded != null;
  }

  bool hasFinishedAnimationDown = false;
  bool hasTapUp = false;

  @override
  Widget build(BuildContext context) {
    final result = _build(context);
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: result);
    } else {
      return result;
    }
  }

  Widget _build(BuildContext context) {
    final appBarPresent = NeumorphicAppBarTheme.of(context) != null;
    final appBarTheme = NeumorphicTheme.currentTheme(context).appBarTheme;

    return GestureDetector(
      onTapDown: (detail) {
        if (clickable) {
          widget.onPressed!();
        }
        hasTapUp = false;
        if (clickable && !pressed) {
          _handlePress();
        }
      },
      onTapUp: (details) {
        if (clickable) {
          widget.onEnded!();
        }
        hasTapUp = true;
        _resetIfTapUp();
      },
      onTapCancel: () {
        hasTapUp = true;
        _resetIfTapUp();
      },
      child: animationScale.AnimatedScale(
        scale: _getScale(),
        child: Neumorphic(
          margin: widget.margin ?? const EdgeInsets.all(0),
          drawSurfaceAboveChild: widget.drawSurfaceAboveChild,
          duration: widget.duration,
          curve: widget.curve,
          padding:
              widget.padding ??
              (appBarPresent ? appBarTheme.buttonPadding : null) ??
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          style: initialStyle.copyWith(depth: _getDepth()),
          child: widget.child,
        ),
      ),
    );
  }

  double _getDepth() {
    if (widget.isEnabled) {
      return depth;
    } else {
      return 0;
    }
  }

  double _getScale() {
    if (widget.pressed != null) {
      //defined by the widget that use it
      return widget.pressed!
          ? NeumorphicButton.PRESSED_SCALE
          : NeumorphicButton.UNPRESSED_SCALE;
    } else {
      return pressed
          ? NeumorphicButton.PRESSED_SCALE
          : NeumorphicButton.UNPRESSED_SCALE;
    }
  }
}
