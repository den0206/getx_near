import 'dart:io';

import 'package:getx_near/src/api/api_base.dart';
import 'package:getx_near/src/model/utils/response_api.dart';

class UserAPI extends APIBase {
  UserAPI() : super(EndPoint.user);

  Future<ResponseAPI> signUp(
      {required Map<String, dynamic> userData, File? avatarFile}) async {
    try {
      final Uri uri = setUri("/signup");
      if (avatarFile == null) {
        return await postRequest(uri: uri, body: userData);
      } else {
        return await updateSingleFile(
            uri: uri, body: userData, file: avatarFile);
      }
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> login(Map<String, dynamic> authData) async {
    try {
      final Uri uri = setUri("/login");
      return await postRequest(uri: uri, body: authData);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateUser(
      {required Map<String, dynamic> updateData, File? avatarFile}) async {
    try {
      final Uri uri = setUri("/edit");
      if (avatarFile == null) {
        return await putRequest(uri: uri, body: updateData, useToken: true);
      } else {
        return await updateSingleFile(
          uri: uri,
          body: updateData,
          file: avatarFile,
          type: "PUT",
          useToken: true,
        );
      }
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateLocation(Map<String, dynamic> cood) async {
    try {
      final Uri uri = setUri("/location");
      return await putRequest(uri: uri, body: cood, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> fetchBlocks() async {
    try {
      final Uri uri = setUri("/blocks");
      return await getRequest(uri: uri, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> updateBlock({
    required Map<String, dynamic> userData,
  }) async {
    try {
      final Uri uri = setUri("/updateBlock");
      return await putRequest(uri: uri, body: userData, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }

  Future<ResponseAPI> deleteUser() async {
    try {
      final Uri uri = setUri("/delete");
      return await deleteRequest(uri: uri, body: {}, useToken: true);
    } catch (e) {
      return catchAPIError(e.toString());
    }
  }
}
