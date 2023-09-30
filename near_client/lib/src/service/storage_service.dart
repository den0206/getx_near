import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey {
  user,
  locationSize,
  notificationDistance,
  homeDistance,
  checkTerms,
  loginTutolial,
  loginEmail;

  Future<bool> saveString(dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    final encoded = json.encode(value);
    return pref.setString(name, encoded);
  }

  Future<dynamic> loadString() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(name);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    final decoded = json.decode(value);
    return decoded;
  }

  Future<bool> saveInt(int value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setInt(name, value);
  }

  Future<dynamic> loadInt() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getInt(name);
    if (value == null) {
      print("No Local Storage");
      return null;
    }
    return value;
  }

  Future<bool> saveBool(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(name, value);
  }

  Future<bool?> loadBool() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getBool(name);
    return value;
  }

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(name);
  }
}

Future<void> deleteStorageLogout() async {
  final pref = await SharedPreferences.getInstance();

  await pref.remove(StorageKey.locationSize.name);
  await pref.remove(StorageKey.notificationDistance.name);
  await pref.remove(StorageKey.user.name);
  await pref.remove(StorageKey.loginTutolial.name);
}

Future<void> deleteAllStorage() async {
  final pref = await SharedPreferences.getInstance();

  await pref.clear();
}
