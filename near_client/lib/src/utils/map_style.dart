import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _mapStyle = [
  {
    "featureType": "administrative",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#d6e2e6"}
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#cfd4d5"}
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#7492a8"}
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      {"lightness": 25}
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#dde2e3"}
    ]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#cfd4d5"}
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#dde2e3"}
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#7492a8"}
    ]
  },
  {
    "featureType": "landscape.natural.terrain",
    "elementType": "all",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#dde2e3"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#588ca4"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {"saturation": -100}
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#a9de83"}
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#bae6a1"}
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#c6e8b3"}
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#bae6a1"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#41626b"}
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {"saturation": -45},
      {"lightness": 10},
      {"visibility": "on"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#c1d1d6"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {"color": "#a6b5bb"}
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.icon",
    "stylers": [
      {"visibility": "on"}
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#9fb6bd"}
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#ffffff"}
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#ffffff"}
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.icon",
    "stylers": [
      {"saturation": -70}
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#b4cbd4"}
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#588ca4"}
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "all",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#008cb5"},
      {"visibility": "on"}
    ]
  },
  {
    "featureType": "transit.station.airport",
    "elementType": "geometry.fill",
    "stylers": [
      {"saturation": -100},
      {"lightness": -5}
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {"color": "#a6cbe3"}
    ]
  }
];

final mapStyle = jsonEncode(_mapStyle);

// 新宿駅
final initialCameraPosition = CameraPosition(
  target: shinjukuSta,
  zoom: 10,
);

final shinjukuSta = LatLng(35.6875, 139.703056);

Future<BitmapDescriptor> iconFromAsset(
  String assetPath, {
  int size = 150,
  bool addBorder = false,
  Color borderColor = Colors.white,
  double borderSize = 10,
}) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color;

  final double radius = size / 2;

  final Path clipPath = Path();
  clipPath.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      Radius.circular(100)));

  canvas.clipPath(clipPath);

  ByteData data = await rootBundle.load(assetPath);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: size);
  ui.FrameInfo fi = await codec.getNextFrame();

  paintImage(
      fit: BoxFit.cover,
      alignment: Alignment.center,
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      image: fi.image);

  if (addBorder) {
    //draw Border
    paint..color = borderColor;
    paint..style = PaintingStyle.stroke;
    paint..strokeWidth = borderSize;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  final _image =
      await pictureRecorder.endRecording().toImage(size, (size * 1.1).toInt());
  final temp = await _image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(temp!.buffer.asUint8List());
}
