import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/posts/my_posts/near_posts/near_posts_controller.dart';

import '../../../widget/loading_widget.dart';
import '../my_posts_screen.dart';

class NearPostsScreen extends LoadingGetView<NearPostsController> {
  @override
  NearPostsController get ctr => NearPostsController();

  @override
  Widget get child {
    return GetBuilder<NearPostsController>(
      builder: (controller) {
        return CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                print("Refresh");
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == controller.nearPosts.length - 1) {
                    // controller.loadContents();
                    if (controller.cellLoading) return LoadingCellWidget();
                  }
                  final post = controller.nearPosts[index];
                  return PostCell(post: post);
                },
                childCount: controller.nearPosts.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
