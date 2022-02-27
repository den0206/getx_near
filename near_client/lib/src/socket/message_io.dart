import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/socket/socket_base.dart';

class MessageIO extends SocketBase {
  @override
  NameSpace get nameSpace => NameSpace.message;
  @override
  Map<String, dynamic> get query => {"chatRoomId": chatRoomId};

  final String chatRoomId;
  MessageIO(this.chatRoomId);

  //受信
  void addNewMessageListner(Function(Message message) listner) {
    socket.on("new_message", (msg) {
      final newMessage = Message.fromMap(msg);

      listner(newMessage);
    });
  }

  /// 送信
  void sendNewMessage(Message message) {
    socket.emit("new_message", message.toMap());
  }

  void sendUpdateRecent(List<String> userIds) {
    final Map<String, dynamic> data = {
      "chatRoomId": chatRoomId,
      "userIds": userIds,
    };

    socket.emit("update_recent", data);
  }
}
