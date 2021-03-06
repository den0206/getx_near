import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.title,
    required this.descripon,
    required this.onPress,
    required this.icon,
    required this.mainColor,
  }) : super(key: key);

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
            padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  descripon,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: mainColor,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        onPress();
                      },
                      child: Text(
                        "OK",
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
  const CommentDialog({Key? key, required this.comment, required this.buttons})
      : super(key: key);

  final Comment comment;
  final double pad = 20;
  final double avatarPad = 55;
  final Widget buttons;

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
                color: ConstsColor.panelColor,
                borderRadius: BorderRadius.circular(pad),
                boxShadow: [
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
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (comment.isCurrent)
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "??? "),
                            TextSpan(
                                text: "Your Comment",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ))
                          ],
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    comment.text,
                    style: TextStyle(fontSize: 12.sp),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (comment.distance != null) ...[
                  Container(
                    width: double.infinity,
                    child: Text(
                      "${comment.distance} m",
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                ],
                buttons,
              ],
            ),
          ),
          Positioned(
              left: pad,
              right: pad,
              child: CircleImageButton(
                imageProvider: getUserImage(comment.user),
                border: Border.all(color: Colors.white, width: 2),
                size: 80.sp,
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }
}

void showError(String message) {
  if (Get.context == null) return;
  // InvalidTokenException or NoBindDataException????????????,?????????Root ?????????

  showCommonDialog(
    context: Get.context!,
    title: "Error",
    content: message,
    backRoot: false,
  );
}

// ????????????????????????????????????????????????
bool _isDialogShowing = false;

void showCommonDialog({
  required BuildContext context,
  String? title,
  String? content,
  TextAlign? contentAlign = TextAlign.center,
  bool backRoot = false,
  VoidCallback? okAction,
}) {
  // ???????????????????????????????????????????????????????????????????????????
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
                if (backRoot && Navigator.canPop(context))
                  // root????????????
                  Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(okAction != null ? '???????????????' : "OK"),
              isDefaultAction: false,
              isDestructiveAction: false,
            ),
            if (okAction != null)
              CupertinoDialogAction(
                onPressed: () {
                  okAction();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
                isDefaultAction: true,
                isDestructiveAction: true,
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
              child: Text(okAction != null ? '???????????????' : "OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (backRoot && Navigator.canPop(context))
                  // root????????????
                  Navigator.popUntil(context, (route) => route.isFirst);
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
