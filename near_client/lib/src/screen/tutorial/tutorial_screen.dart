import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/tutorial/tutorial_controller.dart';

class TutorialPage extends StatelessWidget {
  TutorialPage({super.key});
  final PageController _pageController = PageController();
  final ValueNotifier<double> _notifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: GetBuilder<TutorialController>(
          init: TutorialController(_pageController, _notifier),
          builder: (controller) {
            return Stack(children: [
              AnimatedBackgroundColor(
                colors: controller.backColors,
                pageController: controller.pageController,
                pageCount: controller.pages.length,
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: controller.pages
                      .asMap()
                      .entries
                      .map(
                        (entry) => _generateTutorialPage(
                          entry.key,
                          controller,
                          entry.value,
                        ),
                      )
                      .toList(),
                ),
              ),
              if (!controller.isFirst)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller.changePage(context, isBack: true);
                      },
                    ),
                  ),
                ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: controller.skipEnable
                        ? () {
                            controller.changePage(context);
                          }
                        : null,
                    child: Text(
                      !controller.isLast ? "スキップ" : "終了",
                      style: TextStyle(
                          color: controller.skipEnable
                              ? Colors.white
                              : Colors.black38),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.94),
                child: SlidingIndicator(
                  indicatorCount: controller.pages.length,
                  notifier: controller.notifier,
                  activeIndicator: Icon(
                    Icons.check_circle,
                    color: controller.currentCollor,
                  ),
                  inActiveIndicator:
                      const Icon(Icons.circle, color: Colors.white),
                  margin: 8,
                  inactiveIndicatorSize: 30,
                  activeIndicatorSize: 35,
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }

  Widget _generateTutorialPage(
      int index, TutorialController controller, Widget child) {
    return SlidingPage(
      page: index,
      notifier: controller.notifier,
      child: child,
    );
  }
}
