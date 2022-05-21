import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getx_near/src/api/notification_api.dart';

enum NotificationType { message, post }

extension NotificationTypeEXT on NotificationType {
  String get title {
    switch (this) {
      case NotificationType.message:
        return "New Message";
      case NotificationType.post:
        return "Help!";
    }
  }
}

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();
  late AndroidNotificationChannel channel;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationAPI _notificationAPI = NotificationAPI();

  @override
  void onInit() async {
    super.onInit();
    await requestPermission();
    listenForeground();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initService() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FOREGROUND");
        showNotification(message);
      },
    );
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("BackGround");
    showNotification(message);
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      // android/app/src/main/res/raw
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
            playSound: true,
            sound: RawResourceAndroidNotificationSound("HELP!.wav"),
          ),
          iOS: IOSNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
            sound: 'HELP!.wav', //←Xcodeにドロップしたファイル名
          ),
        ),
      );
    }
  }

  /// MARK Send
  Future<void> pushPostNotification({
    required List<String> tokens,
    required NotificationType type,
    required String content,
  }) async {
    final Map<String, dynamic> data = {
      "registration_ids": tokens,
      "notification": {
        "Title": type.title,
        "body": content,
        "content_available": true,
        "priority": "high",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      "data": {
        "priority": "high",
        "sound": "HELP!.wav",
        // "sound": "app_sound.wav",
        "content_available": true,
        "bodyText": content,
      }
    };

    final res = await _notificationAPI.sendNotification(data);

    print("Push Notification! ${tokens.length}");
    print(res.toString());
  }
}
