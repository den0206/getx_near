import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_near/src/api/comment_api.dart';
import 'package:getx_near/src/api/post_api.dart';
import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/screen/map/map_screen.dart';
import 'package:getx_near/src/screen/widget/loading_widget.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PostDetailController extends LoadingGetController {
  final Post post = Get.arguments;
  final PanelController panelController = PanelController();
  final TextEditingController commentContoller = TextEditingController();
  final PostAPI _postAPI = PostAPI();
  final CommentAPI _commentAPI = CommentAPI();
  final LocationService _locationService = LocationService();

  final List<Comment> comments = [];

  RxBool get buttonEnable {
    return (commentContoller.text != "").obs;
  }

  bool showCommentTx = false;
  double maxPanelHeight = 100;

  @override
  void onInit() async {
    super.onInit();
    print(post.toString());
    print(post.isLiked);
    await getComments();
  }

  void setMaxBarHeight(double maxHeight) {
    maxPanelHeight = maxHeight;
    update();
  }

  void showTx() {
    showCommentTx = !showCommentTx;
    update();
  }

  Future<void> getComments() async {
    isLoading.call(true);
    await Future.delayed(Duration(seconds: 1));
    try {
      final res = await _commentAPI.getComment(post.id);
      if (!res.status) return;
      final items = List<Map<String, dynamic>>.from(res.data);
      final temp = List<Comment>.from(
          items.map((m) => Comment.fromMapWithPost(m, post)));
      comments.addAll(temp);

      comments.map((e) => e.distance).toList().sort();

      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }

  Future<void> addandRemoveLike() async {
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

  Future<void> addComment() async {
    isLoading.call(true);

    await Future.delayed(Duration(seconds: 1));

    try {
      var res;
      if (useMap) {
        final Position current = await _locationService.getCurrentPosition();
        final Map<String, dynamic> body = {
          "text": commentContoller.text,
          "postId": post.id,
          "longitude": current.longitude,
          "latitude": current.latitude,
        };
        res = await _commentAPI.addPost(body);
      } else {
        /// Dummy
        res = await _commentAPI.generateDummy(post, 2000);
      }

      if (!res.status) return;

      if (useMap) {
        final newComment = Comment.fromMapWithPost(res.data, post);
        comments.insert(0, newComment);
      } else {
        final items = List<Map<String, dynamic>>.from(res.data);
        final temp = List<Comment>.from(
            items.map((m) => Comment.fromMapWithPost(m, post)));

        comments.addAll(temp);
      }
      showTx();
      commentContoller.clear();
      comments.sort((a, b) => a.distance!.compareTo(b.distance!));

      update();
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.call(false);
    }
  }
}
