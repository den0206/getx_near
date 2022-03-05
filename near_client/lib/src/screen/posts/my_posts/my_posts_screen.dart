import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
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
          physics: AlwaysScrollableScrollPhysics(),
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
              delegate: AvatarsArea(controller),
              pinned: true,
              floating: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == controller.posts.length - 1) {
                    controller.loadContents();
                    if (controller.cellLoading) return LoadingCellWidget();
                  }
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

class AvatarsArea extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 10.h;

  @override
  double get minExtent => 10.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  final MyPostsController controller;
  AvatarsArea(this.controller);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
          color: ConstsColor.panelColor,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListView.builder(
        itemCount: controller.relationComments.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final comment = controller.relationComments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleImageButton(
              imageProvider: getUserImage(comment.user),
              size: 35.sp,
              border: Border.all(color: Colors.black, width: 2),
              addShadow: false,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
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
        GestureDetector(
          onTap: () {
            controller.showPostDetail(post);
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 70.w,
                  child: AutoSizeText(
                    post.content,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    minFontSize: 10,
                    maxLines: 2,
                  ),
                ),
                _postIcon(
                  Icons.comment,
                  "${post.comments.length}",
                  Colors.brown,
                ),
                _postIcon(
                  Icons.warning_amber,
                  "${post.likes.length}",
                  ConstsColor.cautionColor,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }

  Column _postIcon(IconData icon, String title, Color mainColor) {
    return Column(
      children: [
        Icon(
          icon,
          color: mainColor,
          size: 13.sp,
        ),
        Text(
          title,
          style: TextStyle(color: mainColor),
        )
      ],
    );
  }
}
