import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/neumorphic_style.dart';
import '../post_detail/post_detail_screen.dart';

class MyPostsScreen extends LoadingGetView<MyPostsController> {
  @override
  MyPostsController get ctr => MyPostsController();

  // 強制的にclose する
  @override
  bool get isForceDelete => true;

  @override
  Widget get child {
    return GetBuilder<MyPostsController>(
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
            // SliverPersistentHeader(
            //   delegate: AvatarsArea(controller),
            //   pinned: true,
            //   floating: false,
            // ),
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
                print("Call");
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleImageButton(
        imageProvider: getUserImage(comment.user),
        size: 35.sp,
        addShadow: false,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return CommentDialog(
                comment: comment,
                buttons: !comment.isCurrent
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            width: 30.w,
                            height: 40,
                            background: Colors.grey,
                            titleColor: Colors.white,
                            title: "キャンセル",
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CustomButton(
                            width: 30.w,
                            height: 40,
                            background: ConstsColor.mainGreenColor,
                            title: "Message",
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (onMessage != null) onMessage!();
                            },
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                          width: 100,
                          height: 40,
                          background: ConstsColor.mainGreenColor,
                          title: "Yes",
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class PostCell extends StatelessWidget {
  const PostCell({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final _ =
            await Get.toNamed(PostDettailScreen.routeName, arguments: post);
      },
      child: Neumorphic(
        style: commonNeumorphic(depth: 0.4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 70.w,
              child: AutoSizeText(
                post.content,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                minFontSize: 10,
                maxLines: 3,
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
