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
  const CommentDialog({Key? key, required this.comment}) : super(key: key);

  final Comment comment;
  final double pad = 20;
  final double avatarPad = 55;

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
                SizedBox(
                  height: 20,
                ),
                Text(
                  comment.text,
                  style: TextStyle(fontSize: 12.sp),
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
                Align(
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
                )
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

Future showError(String? message) {
  return showDialog(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: message != null ? Text(message) : Text("UnknownError"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
