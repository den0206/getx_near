import 'dart:convert';

import 'package:getx_near/src/service/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';

// abstract class MarkerIdentifer {
//   String get id;
//   LatLng get coordinate;
//   String get content;
// }

class Post extends JsonModel {
  final String id;
  final String content;
  final User user;
  final int emergency;
  final LatLng coordinate;
  final DateTime createdAt;

  List<String> likes;
  List<String> comments;

  Post({
    required this.id,
    required this.content,
    required this.user,
    required this.emergency,
    required this.coordinate,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  bool get isLiked {
    final currentUser = AuthService.to.currentUser.value;
    if (currentUser == null) return false;
    return likes.contains(currentUser.id);
  }

  AlertLevel get level {
    return getAlert(emergency.toDouble());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      "latitude": coordinate.latitude,
      "user": user.toMap(),
      'longitude': coordinate.longitude,
      "emergency": emergency,
      'createdAt': createdAt.toIso8601String(),
      "likes": likes,
      "comments": comments
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    final cood = List<double>.from(map["location"]["coordinates"]);

    /// CAUTION mongoose lat: [1], lng[0]
    final latLng = LatLng(cood[1], cood[0]);

    return Post(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      user: User.fromMap(map["userId"]),
      emergency: map["emergency"],
      coordinate: latLng,
      createdAt: DateTime.parse(map["createdAt"]).toUtc(),
      likes: List<String>.from(map["likes"] ?? []),
      comments: List<String>.from(map["comments"] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, content: $content, user: $user, emergency: $emergency, coordinate: $coordinate, createdAt: $createdAt, likes: $likes, comments: $comments)';
  }
}
