import 'package:get/route_manager.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';

class PostDetailController extends LoadingGetController {
  final Post post = Get.arguments;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
