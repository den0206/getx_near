import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

class MyPostsScreen extends LoadingGetView<MyPostsController> {
  @override
  MyPostsController get ctr => MyPostsController();

  @override
  Widget get child {
    return GetBuilder<MyPostsController>(
      builder: (controller) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: ConstsColor.panelColor,
              title: Text("TOP"),
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await controller.refreshPosts();
              },
            ),
            SliverPersistentHeader(
              delegate: AvatarsArea(),
              pinned: true,
              floating: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final post = controller.posts[index];
                  return PostCell(post: post);
                },
                childCount: controller.posts.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PostCell extends GetView<MyPostsController> {
  const PostCell({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(post.content),
          onTap: () {
            controller.showPostDetail(post);
          },
        ),
        Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }
}

class AvatarsArea extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 10.h;

  @override
  double get minExtent => 10.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
          color: ConstsColor.panelColor,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleImageButton(
              imageProvider:
                  Image.asset("assets/images/default_user.png").image,
              size: 35.sp,
              border: Border.all(color: Colors.white, width: 2),
              addShadow: false,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
