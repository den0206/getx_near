import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class CommentAPI extends APIBase {
  CommentAPI() : super(EndPoint.comment);

  Future<ResponseAPI> getComment(String postId, String? nextCursor) async {
    final limit = 10;
    final Map<String, dynamic> query = {
      "postId": postId,
      "limit": limit.toString()
    };

    if (nextCursor != null) query["cursor"] = nextCursor;

    try {
      final Uri uri = setUri("/get", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> addPost(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/add");
      return await postRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> generateDummy(Post post, double radius) async {
    final Map<String, dynamic> query = {
      "postId": post.id,
      "lat": post.coordinate.latitude.toString(),
      "lng": post.coordinate.longitude.toString(),
      "radius": radius.toString()
    };

    try {
      final Uri uri = setUri("/dummy", query);
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
