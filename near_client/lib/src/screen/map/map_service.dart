import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_near/src/model/post.dart';
import 'package:getx_near/src/model/utils/visibleRegion.dart';
import 'package:getx_near/src/service/location_service.dart';
import 'package:getx_near/src/utils/dummy_generator.dart';
import 'package:getx_near/src/utils/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:sizer/sizer.dart';

final double panelMinHeight = 10.h;
final double panelMaxHeight = 40.h;
final double mapButtonHeight = 13.h;
final double logoHeifht = panelMinHeight + mapButtonHeight;

class MapService {
  late GoogleMapController googleController;

  GlobalKey mapKey = GlobalKey();
  late Size _mapSize;
  VisibleRegion? visibleRegion;

  final Map<MarkerId, Marker> _markers = {};
  final Map<PolylineId, Polyline> _polyLines = {};
  final Map<PolygonId, Polygon> _polygons = {};
  final Map<CircleId, Circle> _circles = {};

  Set<Marker> get markers => _markers.values.toSet();
  Set<Polyline> get polylines => _polyLines.values.toSet();
  Set<Polygon> get polygons => _polygons.values.toSet();
  Set<Circle> get circles => _circles.values.toSet();

  final LocationService locationService = LocationService();

  final RxDouble buttonSpaceHeight = mapButtonHeight.obs;

  void init(GoogleMapController controller) async {
    controller.setMapStyle(mapStyle);
    this.googleController = controller;
    final RenderBox? mapRenderBox =
        mapKey.currentContext!.findRenderObject()! as RenderBox?;
    if (mapRenderBox == null) throw Exception("Not initialize Map");

    final devicePixelRatio = Get.context!.devicePixelRatio;

    _mapSize = Size(
      mapRenderBox.size.width * devicePixelRatio,
      mapRenderBox.size.height * devicePixelRatio,
    );
  }

  Future<Position> getCurrentPosition() async {
    return await locationService.getCurrentPosition();
  }

  double GetRadiusOnVisible() {
    if (visibleRegion == null) return 0;
    return locationService.getRadiusOnVisible(visibleRegion!);
  }

  void changePanelPosition(double position) {
    if (position == 1)
      buttonSpaceHeight.value = (mapButtonHeight + (panelMaxHeight * 0.8));
    if (position >= 0.8) return;
    buttonSpaceHeight.value = (mapButtonHeight + (panelMaxHeight * position));
  }

  Future<void> setVisibleRegion() async {
    final List<LatLng> coordinates = await Future.wait([
      googleController
          .getLatLng(ScreenCoordinate(x: _mapSize.width.toInt(), y: 0)),
      googleController.getLatLng(ScreenCoordinate(
          x: _mapSize.width.toInt(), y: _mapSize.height.toInt())),
      googleController
          .getLatLng(ScreenCoordinate(x: 0, y: _mapSize.height.toInt())),
      googleController.getLatLng(ScreenCoordinate(x: 0, y: 0)),
    ]);

    visibleRegion = VisibleRegion(
      farEast: coordinates[0],
      nearEast: coordinates[1],
      nearWest: coordinates[2],
      farWest: coordinates[3],
    );
  }

  Future<void> updateCamera(LatLng latLng, {double? setZoom}) async {
    var zoom =
        setZoom == null ? await googleController.getZoomLevel() : setZoom;

    final cameraUpdate = CameraUpdate.newLatLngZoom(
        LatLng(latLng.latitude, latLng.longitude), zoom);
    googleController.animateCamera(cameraUpdate);
  }

  Future<void> setZoom(bool zoomIn) async {
    double zoom = await googleController.getZoomLevel();

    if (!zoomIn) {
      if (zoom - 1 <= 0) {
        return;
      }
    }

    zoom = zoomIn ? zoom + 1 : zoom - 1;
    final bounds = await googleController.getVisibleRegion();
    final northeast = bounds.northeast;
    final southwest = bounds.southwest;
    final center = LatLng(
      (northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2,
    );
    final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
    await googleController.animateCamera(cameraUpdate);
  }

  Future<LatLng> getCenter() async {
    LatLngBounds visibleRegion = await googleController.getVisibleRegion();

    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );

    return centerLatLng;
  }

  void resetMap() {
    _markers.clear();
    _polyLines.clear();
    _polygons.clear();
    _circles.clear();
  }

  Future<void> addPostMarker(Post obj, [Function()? ontap]) async {
    final markerId = MarkerId(obj.id);

    /// user url
    final icon = await MarkerIcon.downloadResizePictureCircle(
      obj.user.avatarUrl ?? dummyUserImageUrl(),
      size: 120,
      addBorder: true,
      borderColor: Colors.white,
      borderSize: 15,
    );

    final marker = Marker(
      markerId: markerId,
      position: obj.coordinate,
      draggable: true,
      icon: icon,
      infoWindow: InfoWindow(
        title: "Sample",
        snippet: obj.content,
      ),
      onTap: ontap,
    );
    _markers[markerId] = marker;
  }

  void addCircle(LatLng latLng, double radius) {
    final circleId = CircleId("center");
    final circle = Circle(
      circleId: circleId,
      strokeColor: Colors.blue,
      strokeWidth: 3,
      radius: radius,
      center: latLng,
      fillColor: Colors.blue.withOpacity(0.3),
    );

    _circles[circleId] = circle;
  }

  void addPolygon(List<LatLng> points) {
    final id = "polygonId";
    final polygonId = PolygonId(id);

    Polygon polygon;

    polygon = Polygon(
      polygonId: polygonId,
      points: points,
      fillColor: Colors.black.withOpacity(0.4),
    );

    _polygons[polygonId] = polygon;
  }

  void showInfoService(String id) {
    googleController.showMarkerInfoWindow(MarkerId(id));
  }
}
