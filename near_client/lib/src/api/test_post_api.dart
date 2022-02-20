import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/response_api.dart';

class TestPostAPI extends APIBase {
  TestPostAPI() : super(EndPoint.testpost);

  Future<ResponseAPI> createPost(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/create");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> getNearPosts(Map<String, dynamic> query) async {
    try {
      final Uri uri = setUri("/near", query);
      print(uri);
      return await getRequest(uri: uri);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
