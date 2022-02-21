import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_near/src/model/custom_exception.dart';
import 'package:getx_near/src/model/response_api.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

abstract class APIBase {
  final String host = Enviroment.getHost();
  final JsonCodec json = JsonCodec();
  final Map<String, String> headers = {"Content-type": "application/json"};

  final EndPoint endPoint;
  APIBase(this.endPoint);

  Uri setUri(String path, [Map<String, dynamic>? query]) {
    final String withPath = "${endPoint.name}${path}";
    return kDebugMode
        ? Uri.http(host, withPath, query)
        : Uri.https(host, withPath, query);
  }

  ResponseAPI _filterResponse(http.Response response) {
    final resJson = json.decode(response.body);
    final responseAPI =
        ResponseAPI.fromMapWithCode(resJson, response.statusCode);
    return _checkStatusCode(responseAPI);
  }

  ResponseAPI _checkStatusCode(ResponseAPI responseAPI) {
    switch (responseAPI.statusCode) {
      case 200:
        return responseAPI;
      case 400:
        throw FetchDataException(responseAPI.message);
      case 401:
      case 403:
        throw UnauthorisedException(responseAPI.message);
      case 404:
        throw NotFoundException(responseAPI.message);
      case 413:
        throw ExceedLimitException(responseAPI.message);
      case 414:
        throw URLTooLongException(responseAPI.message);
      case 429:
      case 529:
        throw TooManyRequestException(responseAPI.message);
      case 456:
        throw QuotaExceedException(responseAPI.message);
      case 503:
        throw ResourceUnavailableException(responseAPI.message);
      case 500:
      default:
        throw BadRequestException(responseAPI.message);
    }
  }
}

extension APIBaseExtention on APIBase {
  Future<ResponseAPI> getRequest({required Uri uri, useToken = false}) async {
    try {
      final res = await http.get(uri, headers: headers);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      // await AuthService.to.logout();
      throw unauth;
    } on SocketException {
      throw Exception("No Internet");
    }
  }

  Future<ResponseAPI> postRequest(
      {required Uri uri,
      required Map<String, dynamic> body,
      useToken = false}) async {
    try {
      final String bodyparams = json.encode(body);
      final res = await http.post(uri, headers: headers, body: bodyparams);
      return _filterResponse(res);
    } on UnauthorisedException catch (unauth) {
      // await AuthService.to.logout();
      throw unauth;
    } on SocketException {
      throw Exception("No Internet");
    }
  }
}

class Enviroment {
  static String getHost() {
    final domainHost = dotenv.env['DOMAIN_HOST'];

    final dubugHost =
        io.Platform.isAndroid ? "10.0.2.2:3000" : "LOCALHOST:3000";

    return kDebugMode ? dubugHost : domainHost!;
  }
}

enum EndPoint { user, testpost }

extension EndPointEXT on EndPoint {
  String get name {
    final String APIVer = "/api/v1";

    switch (this) {
      case EndPoint.user:
        return "$APIVer/user";
      case EndPoint.testpost:
        return "$APIVer/testpost";
    }
  }
}
