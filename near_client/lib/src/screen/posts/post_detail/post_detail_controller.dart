import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/comment_api.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/utils/page_feeds.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/map/map_controller.dart';
import 'package:getx_near/src/screen/map/slide_panel/main_slide_panel_controller.dart';
import 'package:getx_near/src/screen/posts/posts_tab/my_posts/my_posts_controller.dart';
import 'package:getx_near/src/screen/posts/posts_tab/near_posts/near_posts_controller.dart';
import 'package:getx_near/src/screen/widget/Common_showcase.dart';

import 'package:getx_near/src/screen/widget/custom_dialog.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';

import 'package:getx_near/src/socket/post_io.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../../main.dart';
import '../../../service/notification_service.dart';
import '../../widget/animation_widget.dart';

class PostDetailController extends LoadingGetController {
  late Post post = Get.arguments;
  final TextEditingController commentContoller = TextEditingController();
  final PostAPI _postAPI = PostAPI();
  final CommentAPI _commentAPI = CommentAPI();
  final LocationService _locationService = LocationService();
  final ScrollController sc = ScrollController();
  final RxDouble textScale = 1.0.obs;
  late PostIO _postIO;

  final List<Comment> comments = [];
  List<Comment> get sorted {
    final current = comments;
    current.sort((a, b) => a.distance!.compareTo(b.distance!));
    return current;
  }

  RxBool get buttonEnable {
    return (commentContoller.text != "").obs;
  }

  // tutorial
  final GlobalKey tutorialKey1 = GlobalKey();
  final GlobalKey tutorialKey2 = GlobalKey();
  final GlobalKey tutorialKey3 = GlobalKey();
  final GlobalKey tutorialKey4 = GlobalKey();
  final GlobalKey tutorialKey5 = GlobalKey();

  @override
  void onInit() async {
    super.onInit();
    addSocket();
    listenScroll();

    await loadContents();
  }

  @override
  void onClose() {
    sc.dispose();
    _postIO.destroySocket();
    super.onClose();
  }

  void showTutorial(BuildContext context) {
    final temp = [tutorialKey1, tutorialKey2, tutorialKey3, tutorialKey4];
    if (post.expireAt != null) temp.add(tutorialKey5);
    CommonShowCase(temp)..showTutorial(context);
  }

  void listenScroll() {
    sc.addListener(() {
      changeScale();
      changeOffset();
    });
  }

  void addSocket() {
    _postIO = PostIO(this);
    _postIO.initSocket();

    _postIO.addNewCommentListner();
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

    showCellLoading(true);
    await Future.delayed(Duration(seconds: 1));
    try {
      final res = await _commentAPI.getComment(post.id, nextCursor);
      if (!res.status) return;

      final Pages<Comment> pages =
          Pages.fromMap(res.data, Comment.fromJsonModelWithPost, post);
      reachLast = !pages.pageInfo.hasNextPage;
      nextCursor = pages.pageInfo.nextPageCursor;
      final temp = pages.pageFeeds;
      comments.addAll(temp);
    } catch (e) {
      print(e.toString());
    } finally {
      showCellLoading(false);
    }
  }

  Future<void> addComment() async {
    if (commentContoller.text == "") return;
    try {
      final Position current = await _locationService.getCurrentPosition();
      final Map<String, dynamic> body = {
        "text": commentContoller.text,
        "postId": post.id,
        "postUserId": post.user.id,
        "longitude": current.longitude,
        "latitude": current.latitude,
      };
      final res = await _commentAPI.addComment(body);

      if (!res.status) return;

      final newComment = Comment.fromMapWithPost(res.data, post);
      _postIO.sendNewComment(newComment);

      if (!post.isCurrent && post.user.fcmToken.isNotEmpty) {
        // post user に通知を飛ばす
        await NotificationService.to.pushPostNotification(
          tokens: [post.user.fcmToken],
          type: NotificationType.comment,
        );
      }

      commentContoller.clear();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addAndRemoveLike(BuildContext context) async {
    if (!post.isLiked) {
      // Help Animation
      var _overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return HelpAnimatedWidet();
        },
      );
      Navigator.of(context).overlay?.insert(_overlayEntry);
      Timer(Duration(seconds: 2), () => _overlayEntry.remove());
    }

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
    isLoading.call(true);

    try {
      await getToMessScreen(user: comment.user);
    } catch (e) {
      showError(e.toString());
    } finally {
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
    } catch (e) {
      print(e.toString());
    } finally {
      cellLoading = false;
      update();
    }
  }

  // 故意に消した時
  Future<void> deletePost() async {
    if (!post.isCurrent) return;
    try {
      final res = await _postAPI.deletePost(post.id);
      if (!res.status) return;

      if (Get.isRegistered<MyPostsController>() &&
          MyPostsController.to.posts.contains(post)) {
        MyPostsController.to.posts.remove(post);
        MyPostsController.to.update();
      }

      if (Get.isRegistered<NearPostsController>() &&
          NearPostsController.to.nearPosts.contains(post)) {
        NearPostsController.to.nearPosts.remove(post);
        NearPostsController.to.update();

        if (Get.isRegistered<MainSlidePanelController>())
          MainSlidePanelController.to.update();
      }

      // map の更新
      _cleanMap();

      Get.back();
    } catch (e) {
      showError(e.toString());
    }
  }

  void _cleanMap() {
    if (Get.isRegistered<MapController>()) {
      print("delete marker");
      MapController.to.mapService.deletePostMarker(obj: post);
      MapController.to.update();
    }
  }

  // 時間制限で消えた時
  Future<void> expirePost() async {
    _cleanMap();
  }

  Future<void> tryMapLauncher(
      BuildContext context, AvailableMap current) async {
    showCommonDialog(
      context: context,
      title: "外部アプリへ遷移します",
      okAction: () async {
        final locationService = LocationService();
        final currentPosition = await locationService.getCurrentPosition();
        current.showDirections(
          origin: Coords(currentPosition.latitude, currentPosition.longitude),
          originTitle: "貴方の現在地",
          destination: post.coordForLauncher,
          destinationTitle: "${post.user.name} さんの位置",
        );
      },
    );
  }
}
