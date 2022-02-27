import 'package:get/instance_manager.dart';
import 'package:getx_near/src/api/recent_api.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/recent/recent_controller.dart';
import 'package:getx_near/src/service/auth_service.dart';

class RecentExtension {
  final RecentAPI _recentAPI = RecentAPI();
  User get currentUser {
    final current = AuthService.to.currentUser.value;
    assert(current != null);
    return current!;
  }

  Future<String?> createPrivateChatRoom(
      String withUserID, List<User> users) async {
    var chatRoomId;
    final currentUID = currentUser.id;

    final value = currentUID.compareTo(withUserID);
    chatRoomId = value < 0 ? currentUID + withUserID : withUserID + currentUID;

    final userIds = [currentUID, withUserID];
    var tempMembers = userIds;

    final res = await _recentAPI.finadByRoomId(chatRoomId);

    if (!res.status) return null;
    final item = List<Map<String, dynamic>>.from(res.data);
    final recents = List<Recent>.from(item.map((e) => Recent.fromMap(e)));

    if (recents.isNotEmpty) {
      recents.forEach((recent) {
        final String chackId = recent.user.id;
        if (userIds.contains(chackId)) {
          tempMembers.remove(chackId);
        }
      });
    }

    await Future.forEach(tempMembers, (String id) async {
      await saveRecent(id, users, chatRoomId);
      updateRecentSocket(userId: id, chatRoomId: chatRoomId);
    });
    print(tempMembers.length);
    return chatRoomId;
  }

  Future<void> saveRecent(
      String id, List<User> users, String chatRoomId) async {
    final withUser = id == currentUser.id ? users.last : users.first;
    final Map<String, dynamic> body = {
      "userId": id,
      "chatRoomId": chatRoomId,
      "withUserId": withUser.id
    };

    await _recentAPI.creatRecent(body);
  }

  void updateRecentSocket(
      {required String userId, required String chatRoomId}) {
    if (!Get.isRegistered<RecentController>()) return;
    RecentController.to.recentIO
        .sendUpdateRecent(userId: userId, chatRoomId: chatRoomId);
  }

  Future<List<Recent>> updateRecentWithLastMessage(
      {required String chatRoomId, String? lastMessage}) async {
    final res = await _recentAPI.finadByRoomId(chatRoomId);
    if (!res.status) throw Exception("Not find Recent");
    final item = List<Map<String, dynamic>>.from(res.data);
    final recents = List<Recent>.from(item.map((e) => Recent.fromMap(e)));

    String last;

    if (lastMessage != null) {
      last = lastMessage;
    } else {
      last = "Deleted";
    }

    if (recents.isNotEmpty) {
      await Future.forEach(recents, (Recent recent) async {
        await updateRecentItem(recent, last, lastMessage == null);
      });
    }
    return recents;
  }

  Future<void> updateRecentItem(
      Recent recent, String lastMessage, bool isDelete) async {
    final uid = recent.user.id;
    var counter = recent.counter;

    if (currentUser.id != uid) {
      if (!isDelete) {
        counter++;
      } else {
        --counter;
      }
      if (counter < 0) {
        counter = 0;
      }
    }

    final value = {
      "recentId": recent.id,
      "lastMessage": lastMessage,
      "counter": counter,
    };

    await _recentAPI.updateRecent(value);
  }
}
