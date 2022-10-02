import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sizer/sizer.dart';

import '../../../../../model/user.dart';
import '../../../../../utils/neumorphic_style.dart';
import '../../../../widget/neumorphic/nicon_button.dart';
import 'block_list_controller.dart';

class BlockListScreen extends StatelessWidget {
  const BlockListScreen({super.key});

  static const routeName = '/BlockList';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlockListController>(
      init: BlockListController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('ブロック一覧'),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: controller.blocks.length,
            itemBuilder: (context, index) {
              final user = controller.blocks[index];
              return Slidable(
                key: Key(user.id),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      backgroundColor: Colors.yellow,
                      label: "ブロック削除",
                      icon: Icons.message,
                      onPressed: (context) {
                        controller.blockUser(user);
                      },
                    )
                  ],
                ),
                child: UserCell(
                  user: user,
                  onTap: () {
                    controller.tryUnblock(context, user);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class UserCell extends StatelessWidget {
  const UserCell({
    Key? key,
    required this.user,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final User user;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Neumorphic(
        style: commonNeumorphic(depth: selected ? -1.5 : 0.6),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            UserAvatarButton(
              user: user,
              size: 30.sp,
              useNeumorphic: false,
            ),
            SizedBox(
              width: 20,
            ),
            Text(user.name)
          ],
        ),
      ),
    );
  }
}
