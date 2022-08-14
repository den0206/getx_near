import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/utils/dummy_generator.dart';

abstract class JsonModel {
  JsonModel();
  JsonModel.fromMap(Map<String, dynamic> map);
}

class User extends JsonModel {
  final String id;
  String name;
  final String email;

  String fcmToken;
  String? avatarUrl;
  String? sessionToken;
  List<String> blockedUsers;

  bool get isCurrent {
    return id == AuthService.to.currentUser.value?.id;
  }

  bool checkBlock(User user) {
    return this.blockedUsers.contains(user.id);
  }

  bool canContact(User user) {
    return this.blockedUsers.contains(user.id) ||
        user.blockedUsers.contains(this.id);
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.fcmToken,
    required this.blockedUsers,
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
      "blocked": blockedUsers,
      "fcmToken": fcmToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? dummyUserImageUrl(),
      sessionToken: map["sessionToken"],
      blockedUsers: List<String>.from(map["blocked"] ?? []),
      fcmToken: map["fcmToken"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, sessionToken: $sessionToken, fcmToken: $fcmToken)';
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? fcmToken,
    String? avatarUrl,
    List<String>? blockedUsers,
    String? sessionToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }
}

ImageProvider getUserImage(User user) {
  if (user.avatarUrl == null) {
    return Image.asset("assets/images/default_user.png").image;
  } else {
    return Image.network(
      user.avatarUrl!,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress != null) {
          return CircularProgressIndicator();
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return Text("Error");
      },
    ).image;
  }
}
