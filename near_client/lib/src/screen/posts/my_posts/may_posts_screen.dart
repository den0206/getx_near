import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/posts/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';

class MyPostsScreen extends LoadingGetView<MyPostsController> {
  @override
  MyPostsController get ctr => MyPostsController();

  @override
  Widget get child {
    return GetBuilder<MyPostsController>(
      builder: (controller) {
        return Center(
          child: Text("My Posts"),
        );
      },
    );
  }
}
