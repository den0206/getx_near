import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class NotificationAPI extends APIBase {
  final String? serverKey = dotenv.env["FCM_SERVER_KEY"];
  NotificationAPI() : super(EndPoint.notification) {
    this.host = "fcm.googleapis.com";
  }

  Future<ResponseAPI> sendNotification(Map<String, dynamic> body) async {
    try {
      final Uri uri = Uri.https(host, "${endPoint.name}/send");
      if (serverKey == null) throw new Exception("No Server Key");
      headers["Authorization"] = "key=${serverKey}";

      return await postRequest(uri: uri, body: body);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
