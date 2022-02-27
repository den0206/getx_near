import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/screen/message/message_controller.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:sizer/sizer.dart';

class MessageScreen extends LoadingGetView<MessageController> {
  static const routeName = '/Message';
  @override
  MessageController get ctr => MessageController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.extention.withUser.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Scrollbar(
                  controller: controller.sc,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: controller.sc,
                    reverse: true,
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      return Text("Sample");
                    },
                  ),
                ),
              ],
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}

class MessageInput extends GetView<MessageController> {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    color: Colors.black,
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined),
                    color: Colors.grey[500],
                    onPressed: () {},
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller.tx,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            // key: Key("message"),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 16.sp,
            ),
            backgroundColor: Colors.green,
            onPressed: () {
              controller.sendMessage();
            },
          )
        ],
      ),
    );
  }
}
