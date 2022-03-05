import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/api/comment_api.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyPostsController extends LoadingGetController {
  static MyPostsController get to => Get.find();
  final User currentUser = AuthService.to.currentUser.value!;
  final LocationService _locationService = LocationService();

  final List<Post> posts = [];
  final PostAPI _postAPI = PostAPI();

  final List<Comment> relationComments = [];
  final CommentAPI _commentAPI = CommentAPI();

  @override
  void onInit() async {
    super.onInit();
    await loadRelationComments();

    await loadContents();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refreshPosts() async {
    resetParam();
    await loadRelationComments();
    await loadContents();
  }

  void resetParam() {
    posts.clear();
    relationComments.clear();

    reachLast = false;
    nextCursor = null;
    update();
  }

  Future<void> loadContents() async {
    if (useMap) {
      await getPosts();
    } else {
      await getDummy();
    }
  }

  void insertPost(Post post) {
    if (Get.isRegistered<MyPostsController>()) {
      posts.insert(0, post);
      update();
    }
    ;
  }

  /// MARK  Posts
  Future<void> getPosts() async {
    if (reachLast || cellLoading) return;
    showCellLoading(true);
    await Future.delayed(Duration(seconds: 1));

    try {
      final res = await _postAPI.getPosts(currentUser.id, nextCursor);

      if (!res.status) return;
      final Pages<Post> pages = Pages.fromMap(res.data, Post.fromJsonModel);

      reachLast = !pages.pageInfo.hasNextPage;
      nextCursor = pages.pageInfo.nextPageCursor;

      final temp = pages.pageFeeds;
      posts.addAll(temp);
    } catch (e) {
      print(e.toString());
    } finally {
      showCellLoading(false);
    }
  }

  Future<void> getDummy() async {
    if (reachLast) return;

    await Future.delayed(Duration(seconds: 1));

    try {
      final currentPostion = await _locationService.getCurrentPosition();
      final centerPosition =
          LatLng(currentPostion.latitude, currentPostion.latitude);
      final res = await _postAPI.generateDummyMy(centerPosition, 1000);

      if (!res.status) return;
      final items = List<Map<String, dynamic>>.from(res.data);
      final temp = List<Post>.from(items.map((e) => Post.fromMap(e)));

      posts.addAll(temp);
      update();
    } catch (e) {
      print(e.toString());
    } finally {
      reachLast = false;
    }
  }

  /// MARK Comment
  Future<void> loadRelationComments() async {
    try {
      final res = await _commentAPI.getTotalComment();
      if (!res.status) return;

      final items = List<Map<String, dynamic>>.from(res.data);
      final temp = List<Comment>.from(items.map((e) => Comment.fromMap(e)));

      relationComments.addAll(temp);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> showPostDetail(Post post) async {
    final _ = await Get.toNamed(PostDettailScreen.routeName, arguments: post);
  }
}
