import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/posts_tab/my_post_tab_screen.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/date_formate.dart';
import '../../../../utils/neumorphic_style.dart';
import '../../../users/user_detail/user_detail_screen.dart';
import 'my_posts_controller.dart';

class MyPostsScreen extends GetView<MyPostsController> {
  @override
  Widget build(Object context) {
    return GetBuilder<MyPostsController>(
      init: MyPostsController(),
      autoRemove: false,
      builder: (controller) {
        return CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            // SliverAppBar(
            //   pinned: true,
            //   backgroundColor: ConstsColor.mainBackColor,
            //   title: Text("TOP"),
            //   foregroundColor: Colors.black,
            //   elevation: 0,
            // ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await controller.refreshPosts();
              },
            ),
            SliverPersistentHeader(
              delegate: LengthArea(MyPostsType.mine),
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
                  return PostCell(
                    post: post,
                    onTap: () async {
                      await controller.tapCell(post);
                    },
                  );
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
    final int currentIndex = controller.relationComments.length;
    return Container(
      height: 10.h,
      decoration: BoxDecoration(
          color: ConstsColor.mainBackColor,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: ListView.builder(
        itemCount: currentIndex != controller.commentLimit
            ? currentIndex
            : currentIndex + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          if (index == currentIndex) {
            return IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                controller.showRelationComments();
              },
            );
          }
          final comment = controller.relationComments[index];
          return CommentAvatar(comment: comment);
        },
      ),
    );
  }
}

class CommentAvatar extends StatelessWidget {
  const CommentAvatar({
    Key? key,
    required this.comment,
    this.onMessage,
  }) : super(key: key);

  final Comment comment;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context) {
    return UserAvatarButton(
      user: comment.user,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return CommentDialog(
              comment: comment,
              onMessage: onMessage,
            );
          },
        );
      },
    );
  }
}

class PostCell extends StatelessWidget {
  const PostCell({
    Key? key,
    required this.post,
    this.onTap,
  }) : super(key: key);

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: commonNeumorphic(depth: 0.4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CircleImageButton(
                  imageProvider: getUserImage(post.user),
                  size: 30.sp,
                  onTap: () {
                    Get.to(() => UserDetailScreen(user: post.user));
                  },
                ),
                SizedBox(
                  height: 3.sp,
                ),
                if (post.isCurrent) ...[
                  Text(
                    "Yours",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  )
                ] else if (post.distance != null) ...[
                  Text(
                    "約 ${distanceToString(post.distance!)} km",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 6.sp,
                    ),
                  )
                ]
              ],
            ),
            Container(
              width: 60.w,
              child: AutoSizeText(
                post.content,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                minFontSize: 10,
                maxLines: 4,
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
