import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../widget/loading_widget.dart';
import '../contact_controller.dart';

class ContactScreen extends LoadingGetView<ContactController> {
  final key = UniqueKey();
  static const routeName = '/Contact';

  @override
  ContactController get ctr => ContactController();

  @override
  Widget get child {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お問い合わせ'),
      ),
      body: GetBuilder<ContactController>(
        builder: (controller) {
          return controller.connectionStatus
              ? WebView(
                  initialUrl: controller.contactURL,
                  key: key,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (_) {},
                  onPageStarted: (_) {},
                )
              : Center(
                  child: Text("No Internet connection"),
                );
        },
      ),
    );
  }
}
