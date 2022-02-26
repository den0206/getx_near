import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/api/recent_api.dart';
import 'package:getx_near/src/model/recent.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';
import 'package:getx_near/src/screen/message/message_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/message_extention.dart';
import 'package:getx_near/src/socket/recent_io.dart';

class RecentController extends LoadingGetController {
  static RecentController get to => Get.find();
  final List<Recent> recents = [];
  final RecentAPI _recentAPI = RecentAPI();
  final RecentIO recentIO = RecentIO();
  String? nextCursor;
  bool reachLast = false;

  @override
  void onInit() async {
    super.onInit();
    await loadRecents();
    recentIO.initSocket();
    listenRecentUpdate();
  }

  @override
  void onClose() {
    recentIO.destroySocket();
    super.onClose();
  }

  void recetParam() {
    recents.clear();
    update();

    nextCursor = null;
    reachLast = false;
  }

  Future<void> reloadRecents() async {
    recetParam();

    await loadRecents();
  }

  Future<void> loadRecents() async {
    if (reachLast) return;
    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      final res = await _recentAPI.findByUserId(nextCursor);
      if (!res.status) return;

      final Pages<Recent> pages = Pages.fromMap(res.data, Recent.fromJsonModel);
      reachLast = !pages.pageInfo.hasNextPage;
      nextCursor = pages.pageInfo.nextPageCursor;

      final temp = pages.pageFeeds;
      recents.addAll(temp);
      recents.sort((a, b) => b.date.compareTo(a.date));

      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  /// socket
  void listenRecentUpdate() {
    recentIO.listenRecentUpdate((newRecent) {
      if (!recents.map((r) => r.id).contains(newRecent.id)) {
        /// not Load Recents yet.
        print("New One");
        recents.insert(0, newRecent);
      } else {
        print("Replace");
        int index = recents.indexWhere((recent) => recent.id == newRecent.id);
        recents[index] = newRecent;
        recents.sort((a, b) => b.date.compareTo(a.date));
      }

      update();
    });
  }

  Future<void> pushMessageScreen(Recent recent) async {
    final ext = MessageExtention(recent.chatRoomId, recent.withUser);
    final _ = await Get.toNamed(MessageScreen.routeName, arguments: ext);
  }
}
