import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/recent/recent_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

class RecentScreen extends LoadingGetView<RecentController> {
  @override
  RecentController get ctr => RecentController();

  @override
  bool get isFenix => true;

  @override
  Widget get child {
    return GetBuilder<RecentController>(
      builder: (_) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text("Recents"),
              elevation: 0,
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                controller.reloadRecents();
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final recent = controller.recents[index];
                  return RecentCell(recent: recent);
                },
                childCount: controller.recents.length,
              ),
            )
          ],
        );
      },
    );
  }
}

class RecentCell extends GetView<RecentController> {
  const RecentCell({Key? key, required this.recent}) : super(key: key);

  final Recent recent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        controller.pushMessageScreen(recent);
      },
      leading: CircleImageButton(
        imageProvider: getUserImage(recent.withUser),
        size: 30.sp,
      ),
      title: Text(
        recent.withUser.name,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
      subtitle: Container(
        constraints: BoxConstraints(maxWidth: 200),
        child: Text(
          recent.lastMessage,
          maxLines: 2,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: recent.counter != 0
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: Center(
                  child: Text(
                "${recent.counter}",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
            )
          : null,
    );
  }
}
