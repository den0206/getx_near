import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';

class OriginCarousel extends StatefulWidget {
  OriginCarousel({
    Key? key,
    required this.controller,
    required this.itemCount,
    required this.onChange,
    required this.itemBuilder,
  }) : super(key: key);

  final PageController controller;
  final int itemCount;
  final Function(int index) onChange;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  State<OriginCarousel> createState() => _OriginCarouselState();
}

class _OriginCarouselState extends State<OriginCarousel> {
  final pageController = PageController(initialPage: 0, viewportFraction: 0.6);
  late int currentPage;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = pageController.initialPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: PageView.builder(
      itemCount: widget.itemCount,
      controller: pageController,
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
      return currentIndex!.value == index ? 0.8 : 0.6;
    }

    return 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 3.h, left: 3.w),
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1),
                image: backGroundImage,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
