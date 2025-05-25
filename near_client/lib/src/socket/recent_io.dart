import 'package:getx_near/src/api/recent_api.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/socket/socket_base.dart';

class RecentIO extends SocketBase {
  final RecentAPI _recentAPI = RecentAPI();
  final User currentUser = AuthService.to.currentUser.value!;

  @override
  NameSpace get nameSpace => NameSpace.recent;
  @override
  Map<String, dynamic> get query => {"userId": currentUser.id};

  /// MARK  送信
  void sendUpdateRecent({required dynamic userId, required String chatRoomId}) {
    final Map<String, dynamic> data = {
      "userId": userId,
      "chatRoomId": chatRoomId,
    };

    socket.emit("update", data);
  }

  /// MARK 受信

  void listenRecentUpdate(Function(Recent recent) listner) {
    socket.on("update", (data) async {
      final chatRoomId = data["chatRoomId"];
      final res = await _recentAPI.findByUserAndRoomId(chatRoomId);
      if (res.status) {
        final newRecent = Recent.fromMap(res.data);
        listner(newRecent);
      }
    });
  }
}
