import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:getx_near/src/service/auth_service.dart';

abstract class JsonModel {
  JsonModel();
  JsonModel.fromMap(Map<String, dynamic> map);
}

class User extends JsonModel {
  final String id;
  String name;
  final String email;
  final Sex sex;
  String fcmToken;
  String? avatarUrl;
  String? sessionToken;
  List<String> blockedUsers;
  final DateTime createdAt;

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
    required this.sex,
    required this.fcmToken,
    required this.blockedUsers,
    required this.createdAt,
    this.avatarUrl,
    this.sessionToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      "sex": sex.name,
      'avatarUrl': avatarUrl,
      "sessionToken": sessionToken,
      "blocked": blockedUsers,
      'createdAt': createdAt.toUtc().toIso8601String(),
      "fcmToken": fcmToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      sex: getSex(map["sex"]),
      avatarUrl: map['avatarUrl'] ?? null,
      sessionToken: map["sessionToken"],
      blockedUsers: List<String>.from(map["blocked"] ?? []),
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"]).toLocal()
          : DateTime.now(),
      fcmToken: map["fcmToken"] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, sex: $sex, fcmToken: $fcmToken, avatarUrl: $avatarUrl, sessionToken: $sessionToken, blockedUsers: $blockedUsers, createdAt: $createdAt)';
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    Sex? sex,
    String? fcmToken,
    String? avatarUrl,
    List<String>? blockedUsers,
    DateTime? createdAt,
    String? sessionToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sex: sex ?? this.sex,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt ?? this.createdAt,
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

enum Sex {
  man,
  woman;

  String get title {
    switch (this) {
      case Sex.man:
        return "男性";
      case Sex.woman:
        return "女性";
    }
  }

  IconData get icon {
    switch (this) {
      case Sex.man:
        return Icons.male;
      case Sex.woman:
        return Icons.female;
    }
  }

  Color get mainColor {
    switch (this) {
      case Sex.man:
        return Colors.blue.withOpacity(0.5);
      case Sex.woman:
        return Colors.pink.withOpacity(0.8);
    }
  }
}

Sex getSex(String? value) {
  final Sex s = Sex.values.firstWhere(
    (c) => c.name == value,
    orElse: () => Sex.man,
  );
  // if you know Locale use l.locale
  return s;
}
