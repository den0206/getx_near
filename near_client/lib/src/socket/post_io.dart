import 'package:getx_near/src/model/comment.dart';
import 'package:getx_near/src/screen/posts/post_detail/post_detail_controller.dart';
import 'package:getx_near/src/socket/socket_base.dart';

class PostIO extends SocketBase {
  @override
  NameSpace get nameSpace => NameSpace.post;

  @override
  Map<String, dynamic> get query => {"postId": controller.post.id};

  final PostDetailController controller;
  PostIO(this.controller);

  // 受信
  void addNewCommentListner() {
    socket.on("new_comment", (com) {
      print(com);
      final newComment = Comment.fromMapWithPost(com, controller.post);
      controller.comments.add(newComment);
      controller.update();
    });
  }

  /// 送信
  void sendNewComment(Comment comment) {
    socket.emit("new_comment", comment.toMap());
  }
}
