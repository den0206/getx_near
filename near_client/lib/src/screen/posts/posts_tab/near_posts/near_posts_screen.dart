import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:sizer/sizer.dart';
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
            if (controller.isCompEmpty) ...[
              SliverFillRemaining(
                hasScrollBody: false,
                fillOverscroll: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicIconButton(
                      depth: 1,
                      icon: Icon(
                        Icons.location_on,
                        size: 120.sp,
                        color: Colors.redAccent,
                      ),
                      color: Colors.yellow.withOpacity(0.3),
                      onPressed: () async {
                        await controller.getNearPosts();
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "現在地から検索を行う",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        );
      },
    );
  }
}
