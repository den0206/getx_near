import 'dart:convert';

import 'package:getx_near/src/utils/dummy_generator.dart';

class User {
  final String id;
  final String name;
  final String email;

  String? avatarUrl;
  String? sessionToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      "sessionToken": sessionToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? dummyUserImageUrl(),
      sessionToken: map["sessionToken"],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, sessionToken: $sessionToken)';
  }
}
