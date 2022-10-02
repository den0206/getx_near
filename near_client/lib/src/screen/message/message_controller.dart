import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/model/message.dart';
import 'package:getx_near/src/model/utils/custom_exception.dart';
import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/message_extention.dart';
import 'package:getx_near/src/socket/message_io.dart';

class MessageController extends LoadingGetController {
  final RxList<Message> messages = RxList<Message>();
  late MessageExtention extention = Get.arguments;

  final TextEditingController tx = TextEditingController();
  final ScrollController sc = ScrollController();
  late MessageIO _messageIO;

  @override
  void onInit() async {
    super.onInit();
    _addSocket();
    _addSC();
    await loadMessages();
  }

  @override
  void onClose() {
    super.onClose();
    _messageIO.destroySocket();
    sc.dispose();
  }

  void _addSocket() {
    _messageIO = MessageIO(this);
    _messageIO.initSocket();

    /// new message listner
    _messageIO.addNewMessageListner();

    /// read listner
    _messageIO.addReadListner();
  }

  void _addSC() {
    sc.addListener(() async {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        await loadMessages();
      }
    });
  }

  Future<void> _scrollToBottom() async {
    await sc.animateTo(
      sc.position.minScrollExtent,
      duration: 100.milliseconds,
      curve: Curves.easeIn,
    );
  }

  Future<void> loadMessages() async {
    if (extention.reachLast || isLoading.value) return;
    isLoading.call(true);
    await Future.delayed(Duration(seconds: 1));

    try {
      final temp = await extention.loadMessge();
      final unreads = await extention.updateReadList(temp);
      if (unreads.isNotEmpty) _messageIO.sendUpdateRead(unreads);

      messages.addAll(temp);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> sendMessage() async {
    if (tx.text == "") return;
    final current = tx.text;
    tx.clear();

    try {
      final newMessage = await extention.sendMessage(text: current);

      _messageIO.sendNewMessage(newMessage);
      await extention.updateLastRecent(newMessage);

      _messageIO.sendUpdateRecent(extention.userIds);
      await extention.sendNotification(newMessage: newMessage);
      _scrollToBottom();
    } on BlockException catch (e) {
      showError(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteMessage(Message message) async {
    isLoading.call(true);

    try {
      final canDelete = await extention.deleteMessage(message);
      if (!canDelete) return;
      messages.remove(message);
      await extention.updateDeleteRecent();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  bool checkRead(Message message) {
    final withUser = extention.withUser;
    return message.readBy.contains(withUser.id);
  }

  void readUI(String id, String uid) {
    final messageIds = messages.map((m) => m.id).toList();
    if (messageIds.contains(id)) {
      final index = messageIds.indexOf(id);
      final temp = messages[index];
      temp.readBy.add(uid);
      messages[index] = temp;
    }
  }
}
