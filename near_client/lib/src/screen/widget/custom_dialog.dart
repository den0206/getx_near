// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/screen/widget/countdown_timer.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

import '../users/user_detail/user_detail_screen.dart';
import 'neumorphic/nicon_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.descripon,
    required this.onPress,
    required this.icon,
    required this.mainColor,
  });

  final String title;
  final String descripon;

  final Function() onPress;
  final IconData icon;
  final Color mainColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  descripon,
                  style: TextStyle(
                    fontSize: 13.sp,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          textStyle: const TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        onPress();
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: -60,
            child: CircleAvatar(
              backgroundColor: mainColor,
              radius: 60,
              child: Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentDialog extends StatelessWidget {
  const CommentDialog({
    super.key,
    required this.comment,
    this.onMessage,
  });

  final Comment comment;
  final double pad = 30;
  final double avatarPad = 55;
  final VoidCallback? onMessage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(pad)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: avatarPad),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: ConstsColor.mainBackColor,
                borderRadius: BorderRadius.circular(pad),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  )
                ]),
            padding: EdgeInsets.only(
              left: pad,
              top: pad + avatarPad,
              right: pad,
              bottom: pad,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  comment.user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (comment.isCurrent) ...[
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: "※ "),
                            TextSpan(
                              text: "Your Comment",
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
                    ],
                    const Spacer(),
                    if (comment.expireAt != null) ...[
                      CustomCountdownTimer(
                        endTime: comment.expireAt!,
                        onEnd: () {
                          print("Expire Comment");
                        },
                        fontSize: 12,
                      )
                    ],
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    comment.text,
                    style: TextStyle(fontSize: 12.sp),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (comment.distance != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${comment.distance} m",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                ],
                Row(
                  children: [
                    const Spacer(),
                    if (!comment.isCurrent) ...[
                      NeumorphicIconButton(
                        icon: const Icon(
                          Icons.message,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onMessage != null) onMessage!();
                        },
                      ),
                    ],
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: NeumorphicIconButton(
                        icon: const Icon(
                          Icons.person,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(() => UserDetailScreen(user: comment.user));
                        },
                      ),
                    ),
                    NeumorphicIconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: pad,
            right: pad,
            child: Container(
              alignment: Alignment.center,
              child: UserAvatarButton(
                user: comment.user,
                size: 80.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showError(String message) {
  if (Get.context == null) return;
  // InvalidTokenException or NoBindDataException　の場合,遷移をRoot に戻す

  showCommonDialog(
    context: Get.context!,
    title: "Error",
    content: message,
    backRoot: false,
  );
}

// アラートが表示されているかの分岐
bool _isDialogShowing = false;

void showCommonDialog({
  required BuildContext context,
  String? title,
  String? content,
  TextAlign? contentAlign = TextAlign.center,
  bool backRoot = false,
  VoidCallback? okAction,
}) {
  // アラートが表示されている場合、アラートを追加しない
  if (_isDialogShowing) return;

  _isDialogShowing = true;

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content:
              content != null ? Text(content, textAlign: contentAlign) : null,
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                if (backRoot && Navigator.canPop(context)) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: Text(okAction != null ? 'キャンセル' : "OK"),
            ),
            if (okAction != null)
              CupertinoDialogAction(
                onPressed: () {
                  okAction();
                  Navigator.of(context).pop();
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: const Text('OK'),
              )
          ],
        );
      },
    ).then((value) => _isDialogShowing = false);
  }
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: title != null ? Center(child: Text(title)) : null,
          content: content != null
              ? Text(
                  content,
                  textAlign: contentAlign,
                )
              : null,
          actions: [
            TextButton(
              child: Text(okAction != null ? 'キャンセル' : "OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (backRoot && Navigator.canPop(context)) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
            if (okAction != null)
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  okAction();
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    ).then((value) => _isDialogShowing = false);
  }
}
