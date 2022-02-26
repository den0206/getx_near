import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/comment_api.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_controller.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/service/recent_extension.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostDetailController extends LoadingGetController {
  final Post post = Get.arguments;
  final PanelController panelController = PanelController();
  final TextEditingController commentContoller = TextEditingController();
  final PostAPI _postAPI = PostAPI();
  final CommentAPI _commentAPI = CommentAPI();
  final LocationService _locationService = LocationService();
  final ScrollController sc = ScrollController();
  final RxDouble textScale = 1.0.obs;

  final List<Comment> comments = [];
  String? nextCursor;
  bool reachLast = false;

  RxBool get buttonEnable {
    return (commentContoller.text != "").obs;
  }

  @override
  void onInit() async {
    super.onInit();
    listenScroll();
    await getComments();
  }

  @override
  void onClose() {
    sc.dispose();
    super.onClose();
  }

  void listenScroll() {
    sc.addListener(() {
      changeScale();
      changeOffset();
    });
  }

  void changeOffset() {
    if (sc.position.pixels == sc.position.maxScrollExtent) loadContents();
  }

  void changeScale() {
    if (sc.offset <= 0) {
      textScale.call(1);
      return;
    }

    if (sc.offset >= 100 && sc.offset <= 300) {
      textScale.call(0.8);
    } else if (sc.offset >= 300 && sc.offset <= 500) {
      textScale.call(0.7);
    } else if (sc.offset >= 500) {
      textScale.call(0.7);
    }
    if (textScale.value <= 0.7) return;
  }

  Future<void> loadContents() async {
    if (useMap) {
      await getComments();
    } else {
      await getDummy();
    }
  }

  Future<void> addContents() async {
    if (useMap) {
      await addComment();
    } else {
      await getDummy();
    }
  }

  Future<void> getComments() async {
    if (reachLast) return;

    cellLoading = true;
    update();
    await Future.delayed(Duration(seconds: 1));
    try {
      final res = await _commentAPI.getComment(post.id, nextCursor);
      if (!res.status) return;

      final Pages<Comment> pages =
          Pages.fromMap(res.data, Comment.fromJsonModelWithPost, post);
      reachLast = !pages.pageInfo.hasNextpage;
      nextCursor = pages.pageInfo.nextPageCursor;
      final temp = pages.pageFeeds;
      comments.addAll(temp);

      comments.map((e) => e.distance).toList().sort();

      update();
    } catch (e) {
      print(e.toString());
    } finally {
      cellLoading = false;
      update();
    }
  }

  Future<void> addComment() async {
    cellLoading = true;
    update();

    await Future.delayed(Duration(seconds: 1));

    try {
      final Position current = await _locationService.getCurrentPosition();
      final Map<String, dynamic> body = {
        "text": commentContoller.text,
        "postId": post.id,
        "longitude": current.longitude,
        "latitude": current.latitude,
      };
      final res = await _commentAPI.addPost(body);

      if (!res.status) return;

      final newComment = Comment.fromMapWithPost(res.data, post);
      comments.insert(0, newComment);

      commentContoller.clear();
      comments.sort((a, b) => a.distance!.compareTo(b.distance!));
    } catch (e) {
      print(e.toString());
    } finally {
      cellLoading = false;
      update();
    }
  }

  Future<void> addAndRemoveLike() async {
    try {
      final res = await _postAPI.addLike(post.id);
      if (!res.status) return;
      final current = List<String>.from(res.data);
      post.likes = current;

      update();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> pushMessageScreen(Comment comment) async {
    final re = RecentExtension();
    final User currentUser = AuthService.to.currentUser.value!;

    try {
      final withUser = comment.user;
      final chatRoomId =
          await re.createPrivateChatRoom(withUser.id, [currentUser, withUser]);

      if (chatRoomId == null) throw Exception("Not Generate ChatRoom Id");

      Get.until((route) => route.isFirst);

      // message
      MainTabController.to.setIndex(3);
    } catch (e) {
      isLoading.call(false);
    }
  }

  Future<void> getDummy() async {
    cellLoading = true;
    update();
    await Future.delayed(Duration(seconds: 1));

    try {
      final res = await _commentAPI.generateDummy(post, 2000);

      if (!res.status) return;
      final items = List<Map<String, dynamic>>.from(res.data);
      final temp = List<Comment>.from(
          items.map((m) => Comment.fromMapWithPost(m, post)));

      comments.addAll(temp);
      commentContoller.clear();
      comments.sort((a, b) => a.distance!.compareTo(b.distance!));
    } catch (e) {
      print(e.toString());
    } finally {
      cellLoading = false;
      update();
    }
  }
}
