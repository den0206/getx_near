import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MarkerIdentifer {
  String get id;
  LatLng get coordinate;
  String get content;
}

class TestPost extends MarkerIdentifer {
  final String id;
  final String content;
  final int emergency;
  final LatLng coordinate;
  final DateTime createdAt;
  TestPost({
    required this.id,
    required this.content,
    required this.emergency,
    required this.coordinate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      "latitude": coordinate.latitude,
      'longitude': coordinate.longitude,
      "emergency": emergency,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TestPost.fromMap(Map<String, dynamic> map) {
    final cood = List<double>.from(map["location"]["coordinates"]);

    /// CAUTION mongoose lat: [1], lng[0]

    final latLng = LatLng(cood[1], cood[0]);
    return TestPost(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      emergency: map["emergency"],
      coordinate: latLng,
      createdAt: DateTime.parse(map["createdAt"]).toUtc(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TestPost.fromJson(String source) =>
      TestPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TestPost(id: $id, content: $content, emergency: $emergency, coordinate: $coordinate, createdAt: $createdAt)';
  }
}
