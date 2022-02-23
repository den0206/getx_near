import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/comment.dart';

import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/screen/widget/blinking_widget.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/get_size_widget.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostDettailScreen extends LoadingGetView<PostDetailController> {
  static const routeName = '/PostDetail';
  @override
  PostDetailController get ctr => PostDetailController();

  @override
  void backgroundTap(BuildContext context) {
    if (controller.showCommentTx) controller.showTx();
    super.backgroundTap(context);
  }

  @override
  Widget get child {
    final post = controller.post;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstsColor.panelColor,
      body: GetBuilder<PostDetailController>(
        builder: (controller) {
          return SlidingUpPanel(
            controller: controller.panelController,
            minHeight: 0,
            maxHeight: controller.maxPanelHeight,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: ConstsColor.panelColor,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetSizeWidget(
                  onChange: (Size size) {
                    final maxHeight = 100.h - size.height;

                    controller.setMaxBarHeight(maxHeight);
                  },
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: ConstsColor.panelColor,
                        title: Text(post.user.name),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Hero(
                              tag: controller.post.id,
                              child: Container(
                                width: 30.sp,
                                height: 30.sp,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  image: DecorationImage(
                                    image: getUserImage(post.user),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Content",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(minHeight: 10.h, maxHeight: 30.h),
                        child: Text(
                          post.content,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          !post.isLiked
                              ? GestureDetector(
                                  onTap: () {
                                    controller.addandRemoveLike();
                                  },
                                  child: BlinkingWidet(
                                    duration: Duration(milliseconds: 500),
                                    child: HelpButton(
                                      post: post,
                                      size: 23.sp,
                                      uselabel: true,
                                    ),
                                  ),
                                )
                              : HelpButton(
                                  post: post,
                                  size: 23.sp,
                                  uselabel: true,
                                ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 70.w),
                            height: 30,
                            child: LiquidLinearProgressIndicator(
                              value: post.emergency / 100,
                              valueColor:
                                  AlwaysStoppedAnimation(post.level.mainColor),
                              backgroundColor: Color(0xffD6D6D6),
                              borderColor: Colors.grey,
                              borderWidth: 2.0,
                              borderRadius: 12.0,
                              direction: Axis.horizontal,
                              center: Text(
                                "${post.emergency} %",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    controller.comments.isEmpty
                        ? " No Comment"
                        : controller.comments[0].text,
                    style: TextStyle(fontSize: 11.sp),
                  ),
                  onTap: () {
                    controller.panelController.open();
                  },
                ),
              ],
            ),
            panel: CommentBar(),
          );
        },
      ),
    );
  }
}

class CommentBar extends GetView<PostDetailController> {
  const CommentBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Text(
                    "Comment",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${controller.comments.length}"),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      controller.panelController.close();
                    },
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black38,
                  height: 1,
                ),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.comments.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0)
                    return ListTile(
                      title: BlinkingWidet(
                        duration: Duration(seconds: 2),
                        child: Text("Add Comment"),
                      ),
                      leading: CircleImageButton(
                        imageProvider:
                            getUserImage(AuthService.to.currentUser.value!),
                        size: 30.sp,
                        fit: BoxFit.contain,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      onTap: () {
                        controller.showTx();
                      },
                    );

                  final comment = controller.comments[index - 1];
                  return CommentCell(comment: comment);
                },
              ),
            ),
          ],
        ),
        if (controller.showCommentTx)
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 0,
            right: 0,
            child: _commentField(),
          ),
      ],
    );
  }

  Widget _commentField() {
    return Container(
      decoration: BoxDecoration(color: ConstsColor.panelColor),
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: TextFormField(
          controller: controller.commentContoller,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Colors.black,
          autofocus: true,
          maxLines: 1,
          maxLength: 50,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: " Add Comment...",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              counterText: ""),
        ),
        trailing: Builder(builder: (context) {
          return Obx(
            () => IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.blue,
              ),
              onPressed: controller.buttonEnable.value
                  ? null
                  : () {
                      dismisskeyBord(context);
                      controller.addComment();
                    },
            ),
          );
        }),
      ),
    );
  }
}

class CommentCell extends GetView<PostDetailController> {
  const CommentCell({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: CircleImageButton(
          imageProvider: getUserImage(comment.user),
          size: 30.sp,
          fit: BoxFit.contain,
          border: Border.all(color: Colors.white, width: 2),
        ),
        title: Container(
            width: 60.w,
            child: AutoSizeText(
              comment.text,
              style: TextStyle(fontSize: 13.sp, height: 2, letterSpacing: 1.2),
              minFontSize: 6,
              maxLines: 2,
            )),
        trailing:
            comment.distance != null ? Text("${comment.distance} m") : null,
      ),
    );
  }
}
