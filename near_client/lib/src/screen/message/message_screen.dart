import 'package:flutter/material.dart';
import 'package:getx_near/src/screen/message/message_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';

class MessageScreen extends LoadingGetView<MessageController> {
  static const routeName = '/Message';
  @override
  MessageController get ctr => MessageController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Center(
        child: Text(controller.extention.chatRoomId),
      ),
    );
  }
}
