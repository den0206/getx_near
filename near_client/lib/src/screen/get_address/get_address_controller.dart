import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_near/src/api/test_post_api.dart';
import 'package:getx_near/src/service/location_service.dart';

class GetAddressController extends GetxController {
  Position? currentPosition;
  String? currentAddress;

  final TestPostAPI _testPostAPI = TestPostAPI();

  final LocationService locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getCurrentPosition() async {
    currentPosition = await locationService.getCurrentPosition();
  }

  Future<void> formatAddres() async {
    if (currentPosition == null) return;

    final place = await locationService.positionToAddress(currentPosition!);
    currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
  }

  Future<void> sendTestPost() async {
    try {
      await getCurrentPosition();
      await formatAddres();

      final Map<String, dynamic> body = {
        "title": "title",
        "content": "Sammple From Client",
        "longitude": currentPosition!.longitude,
        "latitude": currentPosition!.latitude,
      };

      final res = await _testPostAPI.createPost(body);
      if (!res.status) return;

      update();

      print(res.data);
    } catch (e) {
      print(e.toString());
    } finally {}
  }
}
