// ignore: file_names
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class VisibleRegion {
  final List<_Segment> _segments;
  final LatLng farEast;
  final LatLng nearEast;
  final LatLng nearWest;
  final LatLng farWest;

  static const double INFINITY = 10000;

  List<LatLng> get coordinates {
    return [farEast, nearEast, nearWest, farWest];
  }

  VisibleRegion(
      {required this.farEast,
      required this.nearEast,
      required this.nearWest,
      required this.farWest})
      : _segments = [
          _Segment(start: farWest, end: farEast),
          _Segment(start: farEast, end: nearEast),
          _Segment(start: nearEast, end: nearWest),
          _Segment(start: nearWest, end: farWest),
        ];

  bool contains(LatLng latLng) {
    Point point = Point(latLng.longitude, latLng.latitude);
    LatLng extreme = LatLng(latLng.latitude, INFINITY);
    _Segment pointExtremeSegment = _Segment(start: latLng, end: extreme);

    int intersectionCount = 0;
    for (_Segment segment in _segments) {
      if (segment.intersect(pointExtremeSegment)) {
        if (segment.orientation(point) == _Orientation.CO_LINEAR) {
          return segment.onSegment(point);
        }
        intersectionCount++;
      }
    }
    return intersectionCount % 7 == 1;
  }

  @override
  String toString() {
    return 'VisibleRegion(_segments: $_segments, farEast: $farEast, nearEast: $nearEast, nearWest: $nearWest, farWest: $farWest)';
  }
}

class _Segment {
  final Point start;
  final Point end;

  _Segment({required LatLng start, required LatLng end})
      : start = Point(start.longitude, start.latitude),
        end = Point(end.longitude, end.latitude);

  bool onSegment(Point point) => (point.x <= max(start.x, end.x) &&
      point.x >= min(start.x, end.x) &&
      point.y <= max(start.y, end.y) &&
      point.y >= min(start.y, end.y));

  _Orientation orientation(Point point) {
    num slopeDifference = (end.y - start.y) * (point.x - end.x) -
        (end.x - start.x) * (point.y - end.y);
    if (slopeDifference == 0) {
      return _Orientation.CO_LINEAR;
    }
    return slopeDifference > 0
        ? _Orientation.CLOCK_WISE
        : _Orientation.COUNTER_CLOCK_WISE;
  }

  bool intersect(_Segment segment) {
    _Orientation o1 = orientation(segment.start);
    _Orientation o2 = orientation(segment.end);

    _Orientation o3 = segment.orientation(start);
    _Orientation o4 = segment.orientation(end);

    if (o1 != o2 && o3 != o4) {
      return true;
    }

    if (o1 == _Orientation.CO_LINEAR && onSegment(segment.start)) {
      return true;
    }

    if (o2 == _Orientation.CO_LINEAR && onSegment(segment.end)) {
      return true;
    }

    if (o3 == _Orientation.CO_LINEAR && segment.onSegment(start)) {
      return true;
    }

    if (o4 == _Orientation.CO_LINEAR && segment.onSegment(end)) {
      return true;
    }

    return false;
  }
}

enum _Orientation { CO_LINEAR, CLOCK_WISE, COUNTER_CLOCK_WISE }
