import 'package:getx_near/src/screen/widget/custom_dialog.dart';

abstract class JsonObject {
  void fromMap(Map<String, dynamic> map);
}

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
      message: map['message'],
    );
  }

  // List<T> parseArrayData<T>() {
  //   final items = List<Map<String, dynamic>>.from(data);
  //   final temp = List<T>.from(items.map((m) => T))
  // }

  @override
  String toString() {
    return 'ResponseAPI(status: $status, statusCode: $statusCode, message: $message, data: $data)';
  }
}

ResponseAPI catchAPIError([String message = "Invalid Error"]) {
  /// show Allert
  showError(message);

  return ResponseAPI(
    status: false,
    statusCode: 500,
    data: null,
    message: message,
  );
}
