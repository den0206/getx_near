import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/comment.dart';

import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/screen/widget/blinking_widget.dart';
import 'package:getx_near/src/screen/widget/countdown_timer.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sizer/sizer.dart';

class PostDettailScreen extends LoadingGetView<PostDetailController> {
  static const routeName = '/PostDetail';
  @override
  PostDetailController get ctr => PostDetailController();

  @override
  Widget get child {
    final post = controller.post;
    return Scaffold(
      backgroundColor: ConstsColor.panelColor,
      body: GetBuilder<PostDetailController>(
        builder: (controller) {
          return CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: controller.sc,
            slivers: [
              SliverAppBar(
                pinned: true,
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
                          border: Border.all(color: Colors.white, width: 2),
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
              if (post.expireAt != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomCountdownTimer(endTime: post.expireAt!),
                  ),
                ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: ContentArea(controller),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      HelpButton(
                        post: post,
                        size: 23.sp,
                        onTap: () {
                          controller.addandRemoveLike();
                        },
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
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: NewCommentArea(controller),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  height: 20,
                ),
              ),
              SliverFixedExtentList(
                itemExtent: 80,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final comment = controller.comments[index];
                    return CommentCell(comment: comment);
                  },
                  childCount: controller.comments.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContentArea extends SliverPersistentHeaderDelegate {
  ContentArea(this.controller);

  @override
  double get maxExtent => 25.h;

  @override
  double get minExtent => 15.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  final PostDetailController controller;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final post = controller.post;
    return Container(
      decoration: BoxDecoration(color: ConstsColor.panelColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Content",
              textScaleFactor: controller.textScale.value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Obx(() => Text(
                post.content,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 13.sp),
                // maxLines: 6,
                textScaleFactor: controller.textScale.value,
                // overflow: TextOverflow.ellipsis
              )),
        ],
      ),
    );
  }
}

class NewCommentArea extends SliverPersistentHeaderDelegate {
  NewCommentArea(this.controller);

  @override
  double get maxExtent => 5.h;

  @override
  double get minExtent => 5.h;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  final PostDetailController controller;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
          color: ConstsColor.panelColor,
          border: Border(top: BorderSide(color: Colors.grey))),
      child: ListTile(
        title: BlinkingWidet(
          duration: Duration(seconds: 2),
          child: Text("Add Comment"),
        ),
        leading: CircleImageButton(
          imageProvider: getUserImage(AuthService.to.currentUser.value!),
          size: 30.sp,
          fit: BoxFit.contain,
          border: Border.all(color: Colors.white, width: 2),
        ),
        trailing: Icon(
          Icons.expand_less,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AboveCommentField();
            },
          );
        },
      ),
    );
  }
}

class AboveCommentField extends GetView<PostDetailController> {
  const AboveCommentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ConstsColor.panelColor),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              counterText: ""),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pop(context);
            dismisskeyBord(context);
            controller.addComment();
          },
        ),
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
              style: TextStyle(
                fontSize: 13.sp,
                height: 2,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              minFontSize: 10,
              maxLines: 2,
            )),
        trailing: comment.distance != null
            ? Text(
                "${comment.distance} m",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : null,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return CommentDialog(
                comment: comment,
                buttons: controller.post.isCurrent && !comment.isCurrent
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
                            background: Colors.green,
                            title: "Message",
                            onPressed: () {
                              Navigator.of(context).pop();
                              print(comment.user.id);
                            },
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: CustomButton(
                          width: 100,
                          height: 40,
                          background: Colors.green,
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
