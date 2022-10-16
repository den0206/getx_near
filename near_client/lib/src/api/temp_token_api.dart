import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class TempTokenAPI extends APIBase {
  TempTokenAPI() : super(EndPoint.temptoken);

  Future<ResponseAPI> requestNewEmail(String email) async {
    final body = {"email": email};
    try {
      final Uri uri = setUri("/requestNewEmail");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> verifyEmail(Map<String, dynamic> data) async {
    try {
      final Uri uri = setUri("/verifyEmail");
      return await postRequest(uri: uri, body: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> requestPassword(String email) async {
    final body = {"email": email};
    try {
      final Uri uri = setUri("/requestPassword");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseAPI> verifyPassword(Map<String, dynamic> data) async {
    try {
      final Uri uri = setUri("/verifyPassword");
      return await postRequest(uri: uri, body: data);
    } catch (e) {
      rethrow;
    }
  }
}
