import 'package:get/route_manager.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/message_extention.dart';
import 'package:getx_near/src/socket/message_io.dart';

class MessageController extends LoadingGetController {
  final MessageExtention extention = Get.arguments;
  late MessageIO _messageIO;

  @override
  void onInit() {
    super.onInit();
    _messageIO = MessageIO(extention.chatRoomId);
    _messageIO.initSocket();
  }

  @override
  void onClose() {
    super.onClose();
    _messageIO.destroySocket();
  }
}
