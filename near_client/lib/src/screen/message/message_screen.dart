import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/screen/message/message_controller.dart';
import 'package:getx_near/src/screen/widget/custom_textfield.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/screen/widget/neumorphic/nicon_button.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:getx_near/src/utils/neumorphic_style.dart';
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
                  child: Obx(
                    () => ListView.builder(
                      controller: controller.sc,
                      reverse: true,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return MessageCell(message: message);
                      },
                    ),
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

class MessageCell extends GetView<MessageController> {
  const MessageCell({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: message.isCurrent ? 0 : 10,
        right: message.isCurrent ? 10 : 0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.isCurrent
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              CupertinoContextMenu(
                actions: [
                  CupertinoContextMenuAction(
                    isDefaultAction: true,
                    child: Text("Copy"),
                    onPressed: () async {
                      final data = ClipboardData(text: message.text);
                      await Clipboard.setData(data);
                      Navigator.of(context).pop();
                    },
                  ),
                  if (message.isCurrent)
                    CupertinoContextMenuAction(
                      isDestructiveAction: true,
                      child: Text("Delete"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.deleteMessage(message);
                      },
                    ),
                  CupertinoContextMenuAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
                child: TextBubble(message: message),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.isCurrent
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (controller.checkRead(message) && message.isCurrent)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.done_all,
                      size: 10.sp,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    message.formattedTime,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TextBubble extends StatelessWidget {
  const TextBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Neumorphic(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          style: commonNeumorphic(
            color: message.isCurrent ? Colors.green[300] : Colors.grey[200]!,
            depth: 0.4,
          ).copyWith(
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(message.isCurrent ? 12 : 0),
                bottomRight: Radius.circular(message.isCurrent ? 0 : 12),
              ),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: RichText(
              text: TextSpan(
                text: message.text,
                style: TextStyle(
                    fontSize: 13.sp,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color:
                        message.isCurrent ? Colors.white : Colors.grey[800]!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageInput extends GetView<MessageController> {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller.tx,
              inputType: TextInputType.text,
              labelText: "Message",
              autoFocus: true,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          NeumorphicIconButton(
            iconData: Icons.send,
            color: Colors.green[300],
            iconColor: Colors.white,
            onPressed: () {
              dismisskeyBord(context);
              controller.sendMessage();
            },
          ),
        ],
      ),
    );
  }
}
