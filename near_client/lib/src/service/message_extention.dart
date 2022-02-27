import 'package:getx_near/src/api/messae_api.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/recent_extension.dart';

class MessageExtention {
  final String chatRoomId;
  final User withUser;
  final MessageApi _messageApi = MessageApi();

  final RecentExtension re = RecentExtension();

  User get currentUser {
    final current = AuthService.to.currentUser.value;
    assert(current != null);
    return current!;
  }

  List<String> get userIds {
    return [currentUser.id, withUser.id];
  }

  MessageExtention(this.chatRoomId, this.withUser);

  Future<Message> sendMessage({required String text}) async {
    final Map<String, dynamic> body = {"text": text, "chatRoomId": chatRoomId};

    try {
      final res = await _messageApi.sendMessage(body);
      if (!res.status) throw Exception("Not Message API");
      final newMessage = Message.fromMapWithUser(res.data, currentUser);

      return newMessage;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateLastRecent(Message newMessage) async {
    final remainRecents = await re.updateRecentWithLastMessage(
      chatRoomId: chatRoomId,
      lastMessage: newMessage.text,
    );

    final existIds = remainRecents.map((r) => r.user.id).toList();

    /// Recent が消されているユーザーを求める
    final deletedUsers = userIds.toSet().difference(existIds.toSet()).toList();
    if (deletedUsers.isNotEmpty) {
      print("RECREATE Recents $deletedUsers!");

      /// ReCreate New Recent
      final allUsers = [currentUser, withUser];
      await Future.forEach(deletedUsers, (String id) async {
        await re.saveRecent(id, allUsers, chatRoomId);
      });
    }
  }
}
