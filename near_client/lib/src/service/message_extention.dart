import 'package:getx_near/src/api/messae_api.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/notification_service.dart';
import 'package:getx_near/src/service/recent_extension.dart';

class MessageExtention {
  final String chatRoomId;
  final User withUser;
  MessageExtention(this.chatRoomId, this.withUser);

  bool reachLast = false;
  String? nextCursor;

  final MessageApi _messageApi = MessageApi();
  final RecentExtension re = RecentExtension();

  User get currentUser {
    final current = AuthService.to.currentUser.value;
    assert(current != null);
    return current!;
  }

  List<String> get userIds => [currentUser.id, withUser.id].toSet().toList();

  Future<List<Message>> loadMessge() async {
    final res = await _messageApi.loadMessage(chatRoomId, nextCursor);
    if (!res.status) throw Exception("Cant load messages");

    final Pages<Message> pages = Pages.fromMap(res.data, Message.fromJsonModel);

    reachLast = !pages.pageInfo.hasNextPage;
    nextCursor = pages.pageInfo.nextPageCursor;

    return pages.pageFeeds;
  }

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

  Future<void> sendNotification({required Message newMessage}) async {
    if (withUser.fcmToken != "") {
      final int? badge = await re.getUserBadges(userId: withUser.id);
      await NotificationService.to.pushPostNotification(
        tokens: [withUser.fcmToken],
        type: NotificationType.message,
        badgeNumber: badge ?? null,
      );
    }
  }

  Future<void> updateDeleteRecent() async {
    final remainRecents =
        await re.updateRecentWithLastMessage(chatRoomId: chatRoomId);

    if (remainRecents.isNotEmpty) {
      remainRecents.forEach((Recent recent) {
        re.updateRecentSocket(userId: recent.user.id, chatRoomId: chatRoomId);
      });
    }
  }

  Future<bool> deleteMessage(Message message) async {
    if (!message.isCurrent) throw Exception("Not Math userId");
    try {
      final res = await _messageApi.deleteMessage(message.id);
      if (!res.status) throw Exception("Not Delete message");
      return res.status;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Reat Status
  Future<List<String>> updateReadList(List<Message> messages) async {
    /// unread を絞り出す
    final unreads = messages
        .where((message) => !message.isRead && !message.isCurrent)
        .toList();
    if (unreads.isEmpty) return [];
    await Future.forEach(unreads, (Message message) async {
      if (!message.isRead) await updateRead(message: message);
    });

    return unreads.map((u) => u.id).toList();
  }

  Future<void> updateRead(
      {required Message message, bool useSocket = false}) async {
    final uniqueRead = [currentUser.id, ...message.readBy].toSet().toList();
    final body = {
      "messageId": message.id,
      "readBy": uniqueRead,
    };

    final res = await _messageApi.updateMessage(body);

    if (!res.status) throw Exception("not update read");
  }
}
