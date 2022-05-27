import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/recent/recent_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

import '../../utils/neumorphic_style.dart';

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
    return Slidable(
      key: Key(recent.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            label: "Delete",
            icon: Icons.delete,
            onPressed: (context) {
              controller.deleteRecent(recent);
            },
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          controller.pushMessageScreen(recent);
        },
        child: Container(
          child: Neumorphic(
            style: commonCellNeumorphic(),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                CircleImageButton(
                  imageProvider: getUserImage(recent.withUser),
                  size: 30.sp,
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recent.withUser.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 60.w),
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
                  ],
                ),
                if (recent.counter != 0) ...[
                  Spacer(),
                  Container(
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
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
