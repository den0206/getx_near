import 'package:getx_near/src/screen/widget/custom_dialog.dart';

class ResponseAPI {
  final bool status;
  final int statusCode;
  String? message;
  dynamic data;

  ResponseAPI({
    required this.status,
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory ResponseAPI.fromMapWithCode(Map<String, dynamic> map, int code) {
    return ResponseAPI(
      status: map['status'],
      statusCode: code,
      data: map['data'],
      message: map['message'] != null ? map['message'] : null,
    );
  }

  @override
  String toString() {
    return 'ResponseAPI(status: $status, statusCode: $statusCode, message: $message, data: $data)';
  }
}

ResponseAPI catchAPIError([String message = "Invalid Error"]) {
  /// show Allert
  showError(message);

  print(message);
  return ResponseAPI(
    status: false,
    statusCode: 500,
    data: null,
    message: message,
  );
}
