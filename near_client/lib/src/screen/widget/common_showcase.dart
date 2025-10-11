import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CommonShowCase {
  CommonShowCase(this.widgetIds);

  final List<GlobalKey> widgetIds;

  void showTutorial(BuildContext _) {
    ShowcaseView.get().startShowCase(widgetIds);
  }
}

Showcase commonShowcaseWidget({
  required GlobalKey key,
  required String description,
  required Widget child,
  Color? color,
}) {
  return Showcase.withWidget(
    key: key,
    container: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(description, style: const TextStyle(color: Colors.white)),
    ),
    // height: 50.h,
    // width: 70.w,
    overlayColor: color ?? Colors.black45,
    targetBorderRadius: const BorderRadius.all(Radius.circular(40)),
    child: child,
  );
}

class AppShowcaseWidget extends StatefulWidget {
  const AppShowcaseWidget({
    required this.builder,
    this.onFinish,
    this.onStart,
    this.onComplete,
    this.onDismiss,
    this.autoPlay = false,
    this.autoPlayDelay = const Duration(milliseconds: 2000),
    this.enableAutoPlayLock = false,
    this.blurValue = 0,
    this.scrollDuration = const Duration(milliseconds: 300),
    this.disableMovingAnimation = false,
    this.disableScaleAnimation = false,
    this.enableAutoScroll = false,
    this.disableBarrierInteraction = false,
    this.enableShowcase = true,
    this.globalTooltipActionConfig,
    this.globalTooltipActions,
    this.globalFloatingActionWidget,
    this.hideFloatingActionWidgetForShowcase = const [],
    this.scope,
    super.key,
  });

  final WidgetBuilder builder;
  final VoidCallback? onFinish;
  final OnShowcaseCallback? onStart;
  final OnShowcaseCallback? onComplete;
  final OnDismissCallback? onDismiss;
  final bool autoPlay;
  final Duration autoPlayDelay;
  final bool enableAutoPlayLock;
  final double blurValue;
  final Duration scrollDuration;
  final bool disableMovingAnimation;
  final bool disableScaleAnimation;
  final bool enableAutoScroll;
  final bool disableBarrierInteraction;
  final bool enableShowcase;
  final TooltipActionConfig? globalTooltipActionConfig;
  final List<TooltipActionButton>? globalTooltipActions;
  final FloatingActionBuilderCallback? globalFloatingActionWidget;
  final List<GlobalKey> hideFloatingActionWidgetForShowcase;
  final String? scope;

  @override
  State<AppShowcaseWidget> createState() => _AppShowcaseWidgetState();
}

class _AppShowcaseWidgetState extends State<AppShowcaseWidget> {
  late final String _scope =
      widget.scope ?? widget.key?.toString() ?? widget.hashCode.toString();
  late final ShowcaseView _showcaseView;

  @override
  void initState() {
    super.initState();
    _showcaseView = ShowcaseView.register(
      scope: _scope,
      onFinish: widget.onFinish,
      onStart: widget.onStart,
      onComplete: widget.onComplete,
      onDismiss: widget.onDismiss,
      autoPlay: widget.autoPlay,
      autoPlayDelay: widget.autoPlayDelay,
      enableAutoPlayLock: widget.enableAutoPlayLock,
      blurValue: widget.blurValue,
      scrollDuration: widget.scrollDuration,
      disableMovingAnimation: widget.disableMovingAnimation,
      disableScaleAnimation: widget.disableScaleAnimation,
      enableAutoScroll: widget.enableAutoScroll,
      disableBarrierInteraction: widget.disableBarrierInteraction,
      enableShowcase: widget.enableShowcase,
      globalTooltipActionConfig: widget.globalTooltipActionConfig,
      globalTooltipActions: widget.globalTooltipActions,
      globalFloatingActionWidget: widget.globalFloatingActionWidget,
      hideFloatingActionWidgetForShowcase:
          widget.hideFloatingActionWidgetForShowcase,
    );
  }

  @override
  void didUpdateWidget(covariant AppShowcaseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _showcaseView
      ..autoPlay = widget.autoPlay
      ..autoPlayDelay = widget.autoPlayDelay
      ..enableAutoPlayLock = widget.enableAutoPlayLock
      ..blurValue = widget.blurValue
      ..scrollDuration = widget.scrollDuration
      ..disableMovingAnimation = widget.disableMovingAnimation
      ..disableScaleAnimation = widget.disableScaleAnimation
      ..enableAutoScroll = widget.enableAutoScroll
      ..disableBarrierInteraction = widget.disableBarrierInteraction
      ..enableShowcase = widget.enableShowcase
      ..globalTooltipActionConfig = widget.globalTooltipActionConfig
      ..globalTooltipActions = widget.globalTooltipActions
      ..globalFloatingActionWidget = widget.globalFloatingActionWidget
      ..hideFloatingActionWidgetForShowcase =
          widget.hideFloatingActionWidgetForShowcase;
  }

  @override
  Widget build(BuildContext context) => Builder(builder: widget.builder);

  @override
  void dispose() {
    _showcaseView.unregister();
    super.dispose();
  }
}
