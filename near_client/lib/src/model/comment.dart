import 'dart:convert';

import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/utils/global_functions.dart';

class Comment extends JsonModel {
  final String id;
  final String text;
  final User user;
  final String postId;
  final LatLng coordinate;
  final DateTime createdAt;

  int? distance;

  Comment(
      {required this.id,
      required this.text,
      required this.user,
      required this.postId,
      required this.coordinate,
      required this.createdAt,
      this.distance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'user': user.toMap(),
      'post': postId,
      "latitude": coordinate.latitude,
      'longitude': coordinate.longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      user: User.fromMap(map['userId']),
      postId: map["postId"],
      coordinate: getLatLngFromMongoose(map),
      createdAt: DateTime.parse(map["createdAt"]).toUtc(),
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
      createdAt: DateTime.parse(map["createdAt"]).toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, user: $user, postId: $postId, coordinate: $coordinate, createdAt: $createdAt)';
  }
}
