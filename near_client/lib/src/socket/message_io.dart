import 'package:getx_near/src/socket/socket_base.dart';

class MessageIO extends SocketBase {
  @override
  NameSpace get nameSpace => NameSpace.message;
  @override
  Map<String, dynamic> get query => {"chatRoomId": chatRoomId};

  final String chatRoomId;
  MessageIO(this.chatRoomId);
}
