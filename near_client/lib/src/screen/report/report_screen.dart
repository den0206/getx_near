import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/screen/report/report_controller.dart';
import 'package:getx_near/src/screen/widget/custom_button.dart';
import 'package:sizer/sizer.dart';

import '../../model/message.dart';
import '../../model/post.dart';
import '../../model/user.dart';
import '../widget/loading_widget.dart';

// common show report screen
Future<void> showReportScreen({
  required BuildContext context,
  required User user,
  Message? message,
  Post? post,
}) async {
  await Navigator.of(context)
      .push(
        MaterialPageRoute(
          builder: (context) {
            return ReportScreen(user, message, post);
          },
          fullscreenDialog: true,
          maintainState: false,
        ),
      )
      .then((value) async {
        if (Get.isRegistered<ReportController>()) {
          await Get.delete<ReportController>();
        }
      });
}

class ReportScreen extends LoadingGetView<ReportController> {
  final User user;
  final Message? message;
  final Post? post;

  ReportScreen(this.user, this.message, this.post);

  @override
  ReportController get ctr => ReportController(user, message, post);

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.type.title} ${controller.user.name} の通報'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                constraints: BoxConstraints(maxWidth: 80.w),
                child: TextField(
                  controller: controller.reportField,
                  // autofocus: true,
                  cursorColor: Colors.black,
                  maxLines: 10,
                  // maxLength: 200,
                  style: const TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    hintText: "${"Report"} ${user.name}",
                    focusColor: Colors.black,
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  // onChanged: controller.streamText,
                ),
              ),
              Builder(
                builder: (context) {
                  return CustomButton(
                    title: "Send",
                    background: Colors.green,
                    onPressed: !controller.enableReport.value
                        ? null
                        : () {
                            controller.sendReport(context);
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
