import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:getx_near/src/utils/date_formate.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:getx_near/src/utils/neumorphic_style.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:map_launcher/map_launcher.dart';
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
                  if (post.isCurrent) PoptPopMenu(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleImageButton(
                      imageProvider: getUserImage(post.user),
                      size: 30.sp,
                      addShadow: false,
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
                        size: 20.sp,
                        onTap: () {
                          controller.addAndRemoveLike();
                        },
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 55.w),
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
                      Builder(builder: (context) {
                        return NeumorphicIconButton(
                          iconData: Icons.location_on,
                          iconColor: Colors.redAccent,
                          color: Colors.yellow.withOpacity(0.3),
                          onPressed: () async {
                            final availableMaps =
                                await MapLauncher.installedMaps;

                            await showModalBottomSheet(
                              backgroundColor: ConstsColor.panelColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              context: context,
                              builder: (_) {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: availableMaps.length + 1,
                                  reverse: true,
                                  separatorBuilder: (_, __) {
                                    return Divider();
                                  },
                                  itemBuilder: (context, index) {
                                    if (index != 0) {
                                      final current = availableMaps[index - 1];
                                      return ListTile(
                                        leading: SvgPicture.asset(
                                          current.icon,
                                          width: 30,
                                          height: 30,
                                        ),
                                        title: Text(current.mapName),
                                        onTap: () {
                                          controller.tryMapLauncher(
                                              context, current);
                                        },
                                      );
                                    } else {
                                      return ListTile(
                                        leading: Icon(Icons.close),
                                        title: Text("???????????????"),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      })
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
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              "Comment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("${controller.comments.length}"),
                          ],
                        ),
                      );
                    }

                    if (index == controller.sorted.length &&
                        controller.cellLoading) return LoadingCellWidget();

                    final comment = controller.sorted[index - 1];
                    return CommentCell(comment: comment);
                  },
                  childCount: controller.sorted.length + 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PoptPopMenu extends GetView<PostDetailController> {
  const PoptPopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: ConstsColor.commonBackground,
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case "delete":
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  title: "Dekete",
                  descripon: "continue",
                  icon: Icons.close,
                  mainColor: Colors.red,
                  onPress: () {
                    controller.deletePost();
                  },
                );
              },
            );
            break;
          default:
            return;
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.delete),
                title: Text(
                  "??????",
                )),
          ),
          PopupMenuItem<String>(
            value: 'cancel',
            child: ListTile(
                leading: Icon(Icons.close),
                title: Text(
                  "???????????????",
                )),
          ),
        ];
      },
    );
  }
}

class ContentArea extends SliverPersistentHeaderDelegate {
  ContentArea(this.controller);

  @override
  double get maxExtent => 26.h;

  @override
  double get minExtent => 20.h;

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
                style: TextStyle(fontSize: 12.sp),
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
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
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
            color: ConstsColor.mainGreenColor,
          ),
          onPressed: () {
            Navigator.pop(context);
            dismisskeyBord(context);
            controller.addContents();
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
          addShadow: false,
        ),
        title: Container(
          width: 60.w,
          child: Neumorphic(
            style: commonNeumorphic(depth: 0.4),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: AutoSizeText(
              comment.text,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              minFontSize: 10,
              maxLines: 2,
            ),
          ),
        ),
        trailing: comment.distance != null
            ? Text(
                " ${distanceToString(comment.distance!)} km",
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
                            title: "???????????????",
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
                              controller.pushMessageScreen(comment);
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
