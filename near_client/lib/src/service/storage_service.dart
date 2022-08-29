import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  user,
  locationSize,
  notificationDistance,
  homeDistance,
  checkTerms,
  loginTutolial,
}

extension StorageKeyEXT on StorageKey {
  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
      case StorageKey.locationSize:
        return "locationSize";
      case StorageKey.checkTerms:
        return "checkTerms";
      case StorageKey.notificationDistance:
        return "notificationDistance";
      case StorageKey.homeDistance:
        return "homeDistance";
      case StorageKey.loginTutolial:
        return "loginTutolial";
    }
  }

  Future<bool> saveString(dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    final encoded = json.encode(value);
    return pref.setString(keyString, encoded);
  }

  Future<dynamic> loadString() async {
    final pref = await SharedPreferences.getInstance();
    final value = await pref.getString(keyString);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  Future<bool> saveInt(int value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setInt(keyString, value);
  }

  Future<dynamic> loadInt() async {
    final pref = await SharedPreferences.getInstance();
    final value = await pref.getInt(keyString);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    return value;
  }

  Future<bool> saveBool(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(this.keyString, value);
  }

  Future<bool?> loadBool() async {
    final pref = await SharedPreferences.getInstance();
    final value = await pref.getBool(this.keyString);
    return value ?? null;
  }

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(keyString);
  }
}

Future<void> deleteStorageLogout() async {
  final pref = await SharedPreferences.getInstance();

  await pref.remove(StorageKey.locationSize.keyString);
  await pref.remove(StorageKey.notificationDistance.keyString);
  await pref.remove(StorageKey.user.keyString);
  await pref.remove(StorageKey.loginTutolial.keyString);
}

Future<void> deleteAllStorage() async {
  final pref = await SharedPreferences.getInstance();

  await pref.clear();
}
