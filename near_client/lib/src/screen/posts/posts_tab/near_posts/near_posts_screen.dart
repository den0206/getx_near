import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../my_post_tab_screen.dart';
import '../my_posts/my_posts_screen.dart';
import 'near_posts_controller.dart';

class NearPostsScreen extends GetView<NearPostsController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearPostsController>(
      init: NearPostsController(),
      autoRemove: false,
      builder: (controller) {
        return CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await controller.getNearPosts();
              },
            ),
            SliverPersistentHeader(
              delegate: LengthArea(MyPostsType.near),
              pinned: true,
              floating: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == controller.nearPosts.length - 1) {
                    // controller.loadContents();

                  }
                  final post = controller.nearPosts[index];
                  return PostCell(
                    post: post,
                    onTap: () async {
                      await controller.tapCell(post);
                    },
                  );
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
