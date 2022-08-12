import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getx_near/src/api/report_api.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import '../../model/post.dart';
import '../../model/user.dart';
import '../../utils/global_functions.dart';
import '../widget/loading_widget.dart';

enum ReportType {
  user,
  message,
  post;

  String get title {
    switch (this) {
      case ReportType.user:
        return "ユーザー";
      case ReportType.message:
        return "メッセージ";
      case ReportType.post:
        return "投稿";
    }
  }
}

class ReportController extends LoadingGetController {
  final User user;
  final Message? message;
  final Post? post;

  final ReportAPI _reportAPI = ReportAPI();
  final reportField = TextEditingController();

  ReportType get type {
    if (message != null) {
      return ReportType.message;
    } else if (post != null) {
      return ReportType.post;
    } else {
      return ReportType.user;
    }
  }

  RxBool get enableReport {
    return (reportField.text.isNotEmpty && !user.isCurrent).obs;
  }

  ReportController(this.user, this.message, this.post);

  @override
  void onInit() {
    super.onInit();
    print(type);
  }

  Future<void> sendReport(BuildContext context) async {
    if (user.isCurrent) return;

    isLoading.call(true);
    await Future.delayed(Duration(seconds: 1));
    try {
      Map<String, dynamic> reportData = {
        "reported": user.id,
        "reportedContent": reportField.text,
      };

      switch (type) {
        case ReportType.message:
          reportData["message"] = message?.id;
          break;
        case ReportType.post:
          reportData["post"] = post?.id;
          break;
        default:
          break;
      }

      print(reportData);
      final res = await _reportAPI.sendReport(reportData: reportData);
      if (!res.status) throw Exception("通報できませんでした。");
      showSnackBar(
        title: "Thank you Report!",
        message: "We will check soon!",
        background: Colors.red,
      );
      reportField.clear();
      Navigator.of(context).pop();
    } catch (e) {
      isLoading.call(false);
      showError(e.toString());
    }
  }
}
