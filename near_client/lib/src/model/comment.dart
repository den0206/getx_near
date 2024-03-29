import 'dart:convert';

import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/service/auth_service.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/global_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Comment extends JsonModel {
  final String id;
  final String text;
  final User user;
  final String postId;
  final LatLng coordinate;

  final DateTime? expireAt;
  final DateTime createdAt;

  int? distance;

  bool get isCurrent {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return user.id == currentUser.id;
  }

  Comment({
    required this.id,
    required this.text,
    required this.user,
    required this.postId,
    required this.coordinate,
    this.expireAt,
    required this.createdAt,
    this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': user.toMap(),
      'postId': postId,
      "location": parseToLatlng(coordinate),
      "expireAt": expireAt?.toUtc().toIso8601String(),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      user: User.fromMap(map['userId']),
      postId: map["postId"],
      coordinate: getLatLngFromMongoose(map),
      expireAt: (map["expireAt"] != null)
          ? DateTime.parse(map["expireAt"]).toLocal()
          : null,
      createdAt: DateTime.parse(map["createdAt"]).toLocal(),
    );
  }

  factory Comment.fromMapWithPost(Map<String, dynamic> map, Post post) {
    final from = getLatLngFromMongoose(map);
    final int distance = getDistansePoints(from, post.coordinate);
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      user: User.fromMap(map['userId']),
      postId: map["postId"],
      coordinate: from,
      distance: distance,
      expireAt: (map["expireAt"] != null)
          ? DateTime.parse(map["expireAt"]).toLocal()
          : null,
      createdAt: DateTime.parse(map["createdAt"]).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  // for pagination
  static Comment fromJsonModel(Map<String, dynamic> json) =>
      Comment.fromMap(json);

  static Comment fromJsonModelWithPost(Map<String, dynamic> json, Post post) =>
      Comment.fromMapWithPost(json, post);

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, user: $user, postId: $postId, coordinate: $coordinate, createdAt: $createdAt,expireAt: $expireAt,)';
  }
}
