import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey { user }

extension StorageKeyEXT on StorageKey {
  String get keyString {
    switch (this) {
      case StorageKey.user:
        return "user";
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

  Future<bool> deleteLocal() async {
    final pref = await SharedPreferences.getInstance();
    return await pref.remove(keyString);
  }
}
