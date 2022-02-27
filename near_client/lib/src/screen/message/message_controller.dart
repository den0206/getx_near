import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/message_extention.dart';
import 'package:getx_near/src/socket/message_io.dart';

class MessageController extends LoadingGetController {
  final RxList<Message> messages = RxList<Message>();
  final MessageExtention extention = Get.arguments;

  final TextEditingController tx = TextEditingController();
  final ScrollController sc = ScrollController();
  late MessageIO _messageIO;

  @override
  void onInit() {
    super.onInit();
    _addSocket();
  }

  @override
  void onClose() {
    super.onClose();
    _messageIO.destroySocket();
    sc.dispose();
  }

  void _addSocket() {
    _messageIO = MessageIO(extention.chatRoomId);
    _messageIO.initSocket();

    _messageIO.addNewMessageListner((message) => messages.insert(0, message));
  }

  Future<void> sendMessage() async {
    if (tx.text == "") return;

    try {
      final newMessage = await extention.sendMessage(text: tx.text);
      _messageIO.sendNewMessage(newMessage);
      await extention.updateLastRecent(newMessage);

      _messageIO.sendUpdateRecent(extention.userIds);

      tx.clear();
    } catch (e) {
      print(e.toString());
    }
  }
}
