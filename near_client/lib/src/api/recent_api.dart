import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class RecentAPI extends APIBase {
  RecentAPI() : super(EndPoint.recent);

  Future<ResponseAPI> creatRecent(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/create");
      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateRecent(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/");
      return await putRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> findByUserId(String? nextCursor) async {
    final limit = 10;
    final query = {"limit": limit.toString()};
    if (nextCursor != null) query["cursor"] = nextCursor;
    try {
      final Uri uri = setUri("/userId", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> finadByRoomId(String chatRoomId) async {
    final Map<String, dynamic> query = {"chatRoomId": chatRoomId};
    try {
      final Uri uri = setUri("/roomId", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> findByUserAndRoomId(String chatRoomId) async {
    final Map<String, dynamic> query = {"chatRoomId": chatRoomId};
    try {
      final Uri uri = setUri("/userid/roomId", query);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
