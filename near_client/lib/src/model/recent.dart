import 'dart:convert';

import 'package:getx_near/src/model/user.dart';

class Recent {
  final String id;
  final String chatRoomId;
  final User user;
  final User withUser;
  final String lastMessage;
  int counter;
  final DateTime date;

  Recent({
    required this.id,
    required this.chatRoomId,
    required this.user,
    required this.withUser,
    required this.lastMessage,
    required this.counter,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'user': user.toMap(),
      'withUser': withUser.toMap(),
      'lastMessage': lastMessage,
      'counter': counter,
      'date': date.toIso8601String(),
    };
  }

  factory Recent.fromMap(Map<String, dynamic> map) {
    return Recent(
      id: map['id'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      user: User.fromMap(map['userId']),
      withUser: User.fromMap(map['withUserId']),
      lastMessage: map['lastMessage'] ?? '',
      counter: map['counter']?.toInt() ?? 0,
      date: DateTime.parse(map["updatedAt"]).toUtc(),
    );
  }

  /// for pagination
  static Recent fromJsonModel(Map<String, dynamic> json) =>
      Recent.fromMap(json);

  String toJson() => json.encode(toMap());

  factory Recent.fromJson(String source) => Recent.fromMap(json.decode(source));
}
