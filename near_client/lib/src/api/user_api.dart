import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class UserAPI extends APIBase {
  UserAPI() : super(EndPoint.user);

  Future<ResponseAPI> signUp(Map<String, dynamic> userData) async {
    try {
      final Uri uri = setUri("/signup");
      return await postRequest(uri: uri, body: userData);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> authData) async {
    try {
      final Uri uri = setUri("/login");
      return await postRequest(uri: uri, body: authData);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
