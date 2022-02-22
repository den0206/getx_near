import 'package:flutter/material.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/utils/consts_color.dart';
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
      appBar: AppBar(
        backgroundColor: ConstsColor.panelColor,
        title: Text(post.user.name),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: controller.post.id,
              child: Container(
                width: 100.sp,
                height: 100.sp,
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HelpButton(
                  post: post,
                  size: 23.sp,
                  uselabel: true,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  child: AlertIndicator(
                      intValue: post.emergency, level: post.level),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                height: 30.h,
                child: Text(
                  post.content,
                )),
            Divider(
              color: Colors.black,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white,
                ),
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "I am afdada",
                      style: TextStyle(fontSize: 11.sp),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
