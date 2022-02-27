import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class MessageApi extends APIBase {
  MessageApi() : super(EndPoint.message);

  Future<ResponseAPI> loadMessage(String chatRoomId, String? cursor) async {
    final limit = 10;
    final Map<String, dynamic> query = {
      "chatRoomId": chatRoomId,
      "limit": limit.toString(),
    };
    if (cursor != null) query["cursor"] = cursor;

    try {
      final Uri uri = setUri("/load", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> sendMessage(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/text");
      return await postRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateMessage(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/update");
      return await putRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteMessage(String messageId) async {
    final Map<String, dynamic> body = {"messageId": messageId};

    try {
      final Uri uri = setUri("/delete");
      return await deleteRequest(uri: uri, body: body, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
