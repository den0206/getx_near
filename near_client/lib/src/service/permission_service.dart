import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> checkLocation() async {
    final permission = await Geolocator.requestPermission();
    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return true;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
      case LocationPermission.deniedForever:
        return false;
    }
  }

  Future<void> openSetting() async {
    await openAppSettings();
  }
}
