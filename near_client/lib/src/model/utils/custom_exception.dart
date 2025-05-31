class CustomException implements Exception {
  final String? _message;
  final String _prefix;

  CustomException(this._message, this._prefix);

  @override
  String toString() {
    // var str = "$_prefix";
    // if (_message != null) {
    //   str += _message;
    // }

    return _message ?? _prefix;
  }
}

class FetchDataException extends CustomException {
  FetchDataException(String? message)
    : super(message, "Error During Communication: ");
}

class NotFoundException extends CustomException {
  NotFoundException(String? message) : super(message, "Not Found: ");
}

class ExceedLimitException extends CustomException {
  ExceedLimitException(String? message) : super(message, "ExceedLimit: ");
}

class URLTooLongException extends CustomException {
  URLTooLongException(String? message) : super(message, "Url is Too Long: ");
}

class TooManyRequestException extends CustomException {
  TooManyRequestException(String? message)
    : super(message, "Too Many Request: ");
}

class QuotaExceedException extends CustomException {
  QuotaExceedException(String? message) : super(message, "QuotaExceed: ");
}

class ResourceUnavailableException extends CustomException {
  ResourceUnavailableException(String? message)
    : super(message, "The Resource Unavailable: ");
}

class BadRequestException extends CustomException {
  BadRequestException(String? message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException(String? message) : super(message, "Unauthorised: ");
}

class BlockException extends CustomException {
  BlockException(String? message) : super(message, "Error: ");
}

// 415
class FailNotificationException extends CustomException {
  FailNotificationException(String? message)
    : super(message, "Fail notification: ");
}
