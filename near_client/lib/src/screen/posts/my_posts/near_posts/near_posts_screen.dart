import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/posts/my_posts/near_posts/near_posts_controller.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';
import '../my_posts_screen.dart';

enum MyPostsType { near, mine }

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

class LengthArea extends SliverPersistentHeaderDelegate {
  LengthArea(this.type);

  @override
  double get maxExtent => 8.h;

  @override
  double get minExtent => 6.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  final MyPostsType type;

  int get postsLength {
    switch (type) {
      case MyPostsType.near:
        return NearPostsController.to.nearPosts.length;
      case MyPostsType.mine:
        return MyPostsController.to.posts.length;
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(color: ConstsColor.mainBackColor),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "${postsLength} 件",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
