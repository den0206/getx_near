import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../widget/custom_dialog.dart';
import '../../../../widget/loading_widget.dart';

class ContactController extends LoadingGetController {
  bool connectionStatus = false;
  final contactURL = dotenv.env['CONTACT_URL'];

  @override
  void onInit() async {
    super.onInit();

    await check();
  }

  Future check() async {
    isLoading.call(true);

    try {
      if (contactURL == null) throw Exception("Not Found Contact Url");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }
    } on SocketException catch (_) {
      showError("No Internet");
    } catch (e) {
      connectionStatus = false;
      showError(e.toString());
    } finally {
      isLoading.call(false);
      update();
    }
  }
}
