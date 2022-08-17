import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/posts/posts_tab/comments/comments_controller.dart';
import '../my_post_tab_screen.dart';
import '../my_posts/my_posts_screen.dart';

class CommentsScreen extends StatelessWidget {
  static const routeName = '/RelationComments';
  const CommentsScreen({Key? key}) : super(key: key);

  EdgeInsets caluculatePadding(int index) {
    if (index == 0 || index % 3 == 0) {
      return EdgeInsets.only(left: 10);
    } else if (index % 2 == 0) {
      return EdgeInsets.only(right: 10);
    } else {
      return EdgeInsets.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsController>(
      init: CommentsController(),
      builder: (controller) {
        return CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: LengthArea(MyPostsType.comments),
              pinned: true,
              floating: false,
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final comment = controller.comments[index];

                  return Padding(
                    padding: caluculatePadding(index),
                    child: CommentAvatar(
                      comment: comment,
                      onMessage: () async {
                        await controller.pushMessageScreen(comment);
                      },
                    ),
                  );
                },
                childCount: controller.comments.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
            )
          ],
        );
      },
    );
  }
}
