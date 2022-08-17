import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class ReportAPI extends APIBase {
  ReportAPI() : super(EndPoint.report);

  Future<ResponseAPI> sendReport(
      {required Map<String, dynamic> reportData}) async {
    try {
      final Uri uri = setUri("/create");

      return await postRequest(uri: uri, body: reportData, useToken: true);
    } catch (e) {
      throw e;
    }
  }
}
