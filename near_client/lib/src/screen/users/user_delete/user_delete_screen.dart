import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/users/user_delete/user_delete_controller.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:sizer/sizer.dart';

import '../../widget/loading_widget.dart';

class UserDeleteScreen extends LoadingGetView<UserDeleteController> {
  static const routeName = '/UserDelete';
  @override
  UserDeleteController get ctr => UserDeleteController();

  @override
  Widget get child {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Delete'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "本当にユーザーを削除しても宜しいでしょうか?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "※ 関連のデータは全て削除されます。",
                style: TextStyle(
                  fontSize: 9.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Builder(builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeumorphicIconButton(
                      icon: Icon(
                        Icons.close,
                        size: 35.sp,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    NeumorphicIconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 35.sp,
                      ),
                      onPressed: () {
                        controller.tryDelete(context);
                      },
                    ),
                  ],
                );
              })
            ],
          ),
        ));
  }
}
