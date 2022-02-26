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
      user: map["userId"] != null ? User.fromMap(map['userId']) : _sampleUser,
      withUser: map["withUserId"] != null
          ? User.fromMap(map['withUserId'])
          : _sampleUser,
      lastMessage: map['lastMessage'] ?? '',
      counter: map['counter']?.toInt() ?? 0,
      date: DateTime.parse(map["updatedAt"]).toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Recent.fromJson(String source) => Recent.fromMap(json.decode(source));
}

final User _sampleUser = User(
    id: "621327bfbbdfe1ed98bea4e7", name: "sample", email: "sss@email.com");
