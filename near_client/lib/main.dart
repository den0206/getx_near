import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/app_root.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_preview/device_preview.dart';

import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(DevicePreview(enabled: false, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        defaultTransition: Transition.fade,
        theme: ThemeData(
          scaffoldBackgroundColor: ConstsColor.panelColor,
          primarySwatch: Colors.blue,
        ),
        getPages: AppRoot.pages,
        initialRoute: RootScreen.routeName,
      );
    });
  }
}
