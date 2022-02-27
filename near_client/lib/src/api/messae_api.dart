import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class MessageApi extends APIBase {
  MessageApi() : super(EndPoint.message);

  Future<ResponseAPI> sendMessage(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/text");
      return await postRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
