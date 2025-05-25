import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../widget/custom_dialog.dart';
import '../../../../widget/loading_widget.dart';

class ContactController extends LoadingGetController {
  bool connectionStatus = false;
  final contactURL = dotenv.env['CONTACT_URL'];
  late WebViewController webViewController;

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      check();
    });
  }

  Future<void> initWebView() async {
    webViewController = WebViewController();
    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);

    await webViewController.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          print(progress);
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          showError("No Internet");
        },
        onNavigationRequest: (NavigationRequest request) {
          // if (request.url.startsWith('https://www.youtube.com/')) {
          //   return NavigationDecision.prevent;
          // }
          return NavigationDecision.navigate;
        },
      ),
    );

    await webViewController.loadRequest(Uri.parse(contactURL!));
  }

  Future check() async {
    isLoading.call(true);

    try {
      if (contactURL == null) throw Exception("Not Found Contact Url");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connectionStatus = true;
      }

      await initWebView();
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
