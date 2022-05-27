import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/api/comment_api.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';

class RelationCommentsController extends GetxController {
  final CommentAPI _commentAPI = CommentAPI();
  final List<Comment> comments = [];

  final int limit = 10;
  bool reachLast = false;
  String? nextCursor;

  @override
  void onInit() async {
    super.onInit();
    await loadComments();
  }

  Future<void> loadComments() async {
    if (reachLast) return;
    try {
      final res = await _commentAPI.getTotalComment(
        limit: limit,
        cursor: nextCursor,
      );

      if (!res.status) return;
      final Pages<Comment> pages =
          Pages.fromMap(res.data, Comment.fromJsonModel);

      reachLast = !pages.pageInfo.hasNextPage;
      nextCursor = pages.pageInfo.nextPageCursor;

      comments.addAll(pages.pageFeeds);
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
