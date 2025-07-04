import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:getx_near/src/app_root.dart';
import 'package:getx_near/src/screen/root_screen.dart';
import 'package:getx_near/src/service/notification_service.dart';
import 'package:getx_near/src/utils/consts_color.dart';
import 'package:safe_device/safe_device.dart';
import 'package:sizer/sizer.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Notification BackGround");
  NotificationService.to.extractBadgeFromNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  Get.put(NotificationService());

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // isJailBroken = await SafeDevice.isJailBroken;
  isRealDevice = await SafeDevice.isRealDevice;

  // runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));

  runApp(const MyApp());
}

bool isJailBroken = false;
bool isRealDevice = false;
const bool useMain = true;
const bool useMap = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Help!!!',
          defaultTransition: Transition.fade,
          debugShowCheckedModeBanner: kDebugMode,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('English'), Locale('ja')],
          locale: const Locale('ja', 'JP'),
          theme: ThemeData(
            scaffoldBackgroundColor: ConstsColor.mainBackColor,
            appBarTheme: AppBarTheme(
              backgroundColor: ConstsColor.mainBackColor,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            primarySwatch: Colors.blue,
          ),
          getPages: AppRoot.pages,
          initialRoute: RootScreen.routeName,
        );
      },
    );
  }
}
