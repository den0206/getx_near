import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/app_root.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_near/src/screen/main_tab/main_tab_screen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        getPages: AppRoot.pages,
        initialRoute: MainTabScreen.routeName,
      );
    });
  }
}
