import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

import '../../utils/neumorphic_style.dart';

class OriginCarousel extends StatefulWidget {
  OriginCarousel({
    Key? key,
    required this.pageController,
    required this.itemCount,
    required this.onChange,
    required this.itemBuilder,
  }) : super(key: key);

  final PageController pageController;
  final int itemCount;
  final Function(int index) onChange;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<OriginCarousel> createState() => _OriginCarouselState();
}

class _OriginCarouselState extends State<OriginCarousel> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = widget.pageController.initialPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: PageView.builder(
      itemCount: widget.itemCount,
      controller: widget.pageController,
      itemBuilder: widget.itemBuilder,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
        widget.onChange(index);
      },
    ));
  }
}

class OriginCarouselCell extends StatelessWidget {
  const OriginCarouselCell(
      {Key? key,
      required this.child,
      required this.onTap,
      required this.currentIndex,
      required this.index,
      this.backGroundImage})
      : super(key: key);

  final Widget child;
  final RxnInt? currentIndex;
  final int? index;
  final VoidCallback onTap;
  final DecorationImage? backGroundImage;

  double get scale {
    if (currentIndex != null && index != null) {
      return currentIndex!.value == index ? 0.9 : 0.6;
    }

    return 0.8;
  }

  double get depth {
    if (currentIndex != null && index != null) {
      return currentIndex!.value == index ? 10 : -20;
    }

    return -20;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 3.h, left: 3.w),
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Transform.scale(
            scale: scale,
            child: Neumorphic(
              style: commonNeumorphic(
                  depth: depth, lightSource: LightSource.bottomLeft),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
