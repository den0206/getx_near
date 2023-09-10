import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/screen/users/user_detail/user_detail_screen.dart';
import 'package:getx_near/src/screen/widget/blinking_widget.dart';
import 'package:getx_near/src/screen/widget/common_showcase.dart';
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
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';

import '../../report/report_screen.dart';

class PostDetailScreen extends LoadingGetView<PostDetailController> {
  static const routeName = '/PostDetail';
  @override
  PostDetailController get ctr => PostDetailController();

  @override
  Widget get child {
    final post = controller.post;
    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: ConstsColor.mainBackColor,
          body: GetBuilder<PostDetailController>(
            builder: (controller) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: controller.sc,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: ConstsColor.mainBackColor,
                    title: Text(post.user.name),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    actions: [
                      NeumorphicIconButton(
                        icon: Icon(
                          Icons.description,
                          size: 13.sp,
                        ),
                        onPressed: () {
                          controller.showTutorial(context);
                        },
                      ),
                      PoptPopMenu(post),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: commonShowcaseWidget(
                          key: controller.tutorialKey4,
                          description: "ユーザーのプロフィール画面を表示します。",
                          child: CircleImageButton(
                            imageProvider: getUserImage(post.user),
                            size: 30.sp,
                            addShadow: false,
                            onTap: () {
                              Get.to(() => UserDetailScreen(user: post.user));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (post.expireAt != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.isCurrent) ...[
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(text: "※ "),
                                    TextSpan(
                                      text: "Your Post",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 8.sp,
                                      ),
                                    )
                                  ],
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ] else ...[
                              const Spacer()
                            ],
                            commonShowcaseWidget(
                              key: controller.tutorialKey5,
                              description: "投稿が削除される残り時間です。",
                              child: CustomCountdownTimer(
                                endTime: post.expireAt!,
                                onEnd: () async {
                                  await controller.expirePost();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: ContentArea(controller),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          commonShowcaseWidget(
                            key: controller.tutorialKey1,
                            description: "外部地図アプリでルート検索を行います。",
                            child: NeumorphicIconButton(
                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                              color: Colors.yellow.withOpacity(0.3),
                              onPressed: () async {
                                final availableMaps =
                                    await MapLauncher.installedMaps;

                                await showModalBottomSheet(
                                  backgroundColor: ConstsColor.mainBackColor,
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
                                        return const Divider();
                                      },
                                      itemBuilder: (context, index) {
                                        if (index != 0) {
                                          final current =
                                              availableMaps[index - 1];
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
                                            leading: const Icon(Icons.close),
                                            title: const Text("キャンセル"),
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
                            ),
                          ),
                          commonShowcaseWidget(
                            key: controller.tutorialKey2,
                            description: "当投稿の緊急度を表しています。",
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 55.w),
                              height: 30,
                              child: LiquidLinearProgressIndicator(
                                value: post.emergency / 100,
                                valueColor: AlwaysStoppedAnimation(
                                    post.level.mainColor),
                                backgroundColor: const Color(0xffD6D6D6),
                                borderColor: Colors.grey,
                                borderWidth: 2.0,
                                borderRadius: 12.0,
                                direction: Axis.horizontal,
                                center: Text(
                                  "${post.emergency} %",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          HelpButton(
                            post: post,
                            size: 20.sp,
                            onTap: () {
                              controller.addAndRemoveLike(context);
                            },
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
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      height: 20,
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 80,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Comment",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text("${controller.commentCount}"),
                              ],
                            ),
                          );
                        }

                        if (index == controller.sorted.length &&
                            controller.cellLoading) {
                          return const LoadingCellWidget();
                        }

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
      }),
    );
  }
}

class PoptPopMenu extends GetView<PostDetailController> {
  const PoptPopMenu(this.post, {Key? key}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: ConstsColor.mainBackColor,
      padding: EdgeInsets.zero,
      onSelected: (value) async {
        switch (value) {
          case "delete":
            showDialog(
              context: context,
              builder: (context) {
                return CustomDialog(
                  title: "Delete",
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
          case "report":
            await showReportScreen(
              context: context,
              user: post.user,
              post: post,
            );
            break;
          default:
            return;
        }
      },
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          if (post.isCurrent)
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                  iconColor: Colors.red,
                  leading: Icon(Icons.delete),
                  title: Text(
                    "削除",
                  )),
            )
          else
            const PopupMenuItem<String>(
              value: 'report',
              child: ListTile(
                iconColor: Colors.red,
                leading: Icon(Icons.report),
                title: Text(
                  "通報",
                ),
              ),
            ),
          const PopupMenuItem<String>(
            value: 'cancel',
            child: ListTile(
                leading: Icon(Icons.close),
                title: Text(
                  "キャンセル",
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
  double get maxExtent => 27.h;

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
      height: maxExtent,
      decoration: BoxDecoration(color: ConstsColor.mainBackColor),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Text(
                post.content,
                textAlign: TextAlign.start,
                softWrap: true,
                style: TextStyle(
                  fontSize: 12.sp,
                ),
                // maxLines: 6,
                textScaleFactor: controller.textScale.value,
                // overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        ),
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
    return commonShowcaseWidget(
      key: controller.tutorialKey3,
      description: "コメントをして助ける意思を伝えましょう!",
      child: Container(
        constraints: BoxConstraints(maxHeight: maxExtent),
        decoration: BoxDecoration(
            color: ConstsColor.mainBackColor,
            border: const Border(top: BorderSide(color: Colors.grey))),
        child: ListTile(
          title: const BlinkingWidet(
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
          trailing: const Icon(
            Icons.expand_less,
          ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const AboveCommentField();
              },
            );
          },
        ),
      ),
    );
  }
}

class AboveCommentField extends GetView<PostDetailController> {
  const AboveCommentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ConstsColor.mainBackColor),
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
          decoration: const InputDecoration(
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GestureDetector(
        child: Row(
          children: [
            UserAvatarButton(
              user: comment.user,
              useNeumorphic: false,
              size: 30.sp,
            ),
            const SizedBox(
              width: 20,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60.w),
              child: Neumorphic(
                style: commonNeumorphic(depth: 0.4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            const Spacer(),
            if (comment.distance != null) ...[
              Text(
                " ${distanceToString(comment.distance!)} km",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ]
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return CommentDialog(
                comment: comment,
                onMessage: () async {
                  await controller.pushMessageScreen(comment);
                },
              );
            },
          );
        },
      ),
    );
  }
}
