import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostAPI extends APIBase {
  PostAPI() : super(EndPoint.post);

  Future<ResponseAPI> createPost(Map<String, dynamic> body) async {
    print(body);
    try {
      final Uri uri = setUri("/create");
      return await postRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> getPosts(String userId, String? nextCursor) async {
    final int limit = 10;

    final Map<String, dynamic> query = {
      "userId": userId,
      "limit": limit.toString(),
    };

    if (nextCursor != null) query["cursor"] = nextCursor;

    try {
      final Uri uri = setUri("/myposts", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> getNearPosts(Map<String, dynamic> query) async {
    try {
      final Uri uri = setUri("/near", query);
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> addLike(String postId) async {
    final body = {"postId": postId};
    try {
      final Uri uri = setUri("/like");
      return await putRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> generateDummyAll(
      LatLng centerPoint, double radius) async {
    final Map<String, dynamic> query = {
      "lat": centerPoint.latitude.toString(),
      "lng": centerPoint.longitude.toString(),
      "radius": radius.toString()
    };

    try {
      final Uri uri = setUri("/dummy/all", query);
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> generateDummyMy(LatLng centerPoint, double radius) async {
    final Map<String, dynamic> query = {
      "lat": centerPoint.latitude.toString(),
      "lng": centerPoint.longitude.toString(),
      "radius": radius.toString()
    };

    try {
      final Uri uri = setUri("/dummy/my", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
