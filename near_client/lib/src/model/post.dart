import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_near/src/model/user.dart';
import 'package:getx_near/src/screen/widget/custom_slider.dart';
import 'package:getx_near/src/service/auth_service.dart';

// abstract class MarkerIdentifer {
//   String get id;
//   LatLng get coordinate;
//   String get content;
// }

enum ExpireTime { one_hour, five_hour, one_day, three_day, one_week }

extension ExpireTimeEXT on ExpireTime {
  DateTime get time {
    switch (this) {
      case ExpireTime.one_hour:
        return DateTime.now().add(Duration(hours: 1));
      case ExpireTime.five_hour:
        return DateTime.now().add(Duration(hours: 3));
      case ExpireTime.one_day:
        return DateTime.now().add(Duration(days: 1));
      case ExpireTime.three_day:
        return DateTime.now().add(Duration(days: 3));
      case ExpireTime.one_week:
        return DateTime.now().add(Duration(days: 7));
    }
  }

  String get title {
    switch (this) {
      case ExpireTime.one_hour:
        return "1 Hour";
      case ExpireTime.five_hour:
        return "3 Hour";
      case ExpireTime.one_day:
        return "1 Day";
      case ExpireTime.three_day:
        return "3 Days";
      case ExpireTime.one_week:
        return "1 Week";
    }
  }
}

class Post extends JsonModel {
  final String id;
  final String content;
  final User user;
  final int emergency;
  final LatLng coordinate;

  final DateTime? expireAt;
  final DateTime createdAt;

  List<String> likes;
  List<String> comments;

  Post({
    required this.id,
    required this.content,
    required this.user,
    required this.emergency,
    required this.coordinate,
    this.expireAt,
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
      "expireAt": expireAt?.toIso8601String(),
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
      expireAt: (map["expireAt"] != null)
          ? DateTime.parse(map["expireAt"]).toUtc()
          : null,
      createdAt: DateTime.parse(map["createdAt"]).toUtc(),
      likes: List<String>.from(map["likes"] ?? []),
      comments: List<String>.from(map["comments"] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, content: $content, user: $user, emergency: $emergency, coordinate: $coordinate, expireAt: $expireAt, createdAt: $createdAt, likes: $likes, comments: $comments)';
  }
}
