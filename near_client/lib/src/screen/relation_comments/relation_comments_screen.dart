import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_screen.dart';
import 'package:getx_near/src/screen/relation_comments/relation_comments_controller.dart';

class RelationCommentsScreen extends StatelessWidget {
  static const routeName = '/RelationComments';
  const RelationCommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RelationCommentsController>(
      init: RelationCommentsController(),
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Relation Comments'),
            ),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                return CommentAvatar(
                  comment: comment,
                );
              },
            ));
      },
    );
  }
}
