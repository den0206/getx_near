import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

import '../model/utils/custom_exception.dart';

class NotificationAPI extends APIBase {
  NotificationAPI() : super(EndPoint.notification);

  Future<ResponseAPI> sendNotification(Map<String, dynamic> body) async {
    try {
      final Uri uri = setUri("/send");

      return await postRequest(uri: uri, useToken: true, body: body);
    } catch (e) {
      // 通知エラーの場合はアラートを出さない
      if (e is FailNotificationException) throw e;
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> getBadgesCount({required String userId}) async {
    final q = {"userId": userId};
    try {
      final Uri uri = setUri("/getBadgeCount", q);
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}



  // final String? serverKey = dotenv.env["FCM_SERVER_KEY"];
  // NotificationAPI() : super(EndPoint.notification) {
  //   this.host = "fcm.googleapis.com";
  // }

  // final Uri uri = Uri.https(host, "${endPoint.name}/send");
  // if (serverKey == null) throw new Exception("No Server Key");
  // headers["Authorization"] = "key=${serverKey}";