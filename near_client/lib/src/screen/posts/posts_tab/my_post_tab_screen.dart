import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/posts/posts_tab/comments/comments_controller.dart';
import 'package:getx_near/src/screen/posts/posts_tab/comments/comments_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/consts_color.dart';
import 'my_posts/my_posts_controller.dart';
import 'my_posts/my_posts_screen.dart';
import 'near_posts/near_posts_controller.dart';
import 'near_posts/near_posts_screen.dart';

enum MyPostsType {
  near,
  mine,
  comments;

  String get title {
    switch (this) {
      case MyPostsType.near:
        return "Near By";
      case MyPostsType.mine:
        return "My Posts";
      case MyPostsType.comments:
        return "Comments";
    }
  }

  Widget get screen {
    switch (this) {
      case MyPostsType.near:
        return NearPostsScreen();
      case MyPostsType.mine:
        return MyPostsScreen();
      case MyPostsType.comments:
        return const CommentsScreen();
    }
  }
}

class MyPostTabScreen extends StatelessWidget {
  const MyPostTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: MyPostsType.values.length,
      child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: TabBar(
                  indicatorColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  indicatorWeight: 4,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: MyPostsType.values
                      .map((type) => Tab(
                              child: Text(
                            type.title,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black87,
                            ),
                          )))
                      .toList()),
            ),
          ),
          body: TabBarView(
            children: MyPostsType.values.map((type) => type.screen).toList(),
          )),
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
      case MyPostsType.comments:
        return CommentsController.to.comments.length;
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(color: ConstsColor.mainBackColor),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "$postsLength 件",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
