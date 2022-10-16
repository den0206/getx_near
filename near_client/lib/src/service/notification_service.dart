import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getx_near/main.dart';
import 'package:getx_near/src/api/notification_api.dart';

enum NotificationType {
  message,
  post,
  comment,
}

extension NotificationTypeEXT on NotificationType {
  String get title {
    switch (this) {
      case NotificationType.message:
        return "New Message";
      case NotificationType.post:
        return "Help!";
      case NotificationType.comment:
        return "New Comment";
    }
  }

  String get content {
    switch (this) {
      case NotificationType.message:
        return "新しいメッセージが届きました";
      case NotificationType.post:
        return "近くでポストが投稿されました。";
      case NotificationType.comment:
        return "新しいコメントが届きました";
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

  late bool canBadge;
  int _currentBadge = 0;
  int get currentBadge => _currentBadge;
  set currentBadge(int value) {
    if (value < 0) {
      // 最低 0
      _currentBadge = 0;
    } else if (value > 99) {
      // 最高 99
      _currentBadge = 99;
    } else {
      _currentBadge = value;
    }

    // badge の更新は下記のみ
    _updateBadges();
  }

  @override
  void onInit() async {
    super.onInit();
    listenForeground();
  }

  String get soundPath {
    // iOS only accepts .wav, .aiff, and .caf extensions
    // Android only accepts .wav, .mp3 and .ogg extensions
    return Platform.isIOS ? "help.caf" : "help.wav";
  }

  Future<void> requestPermission() async {
    canBadge = await FlutterAppBadger.isAppBadgeSupported();
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

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _firebaseMessaging.requestPermission();
  }

  Future<String?> getFCMToken() async {
    if (isRealDevice) print(await _firebaseMessaging.getAPNSToken());
    return await _firebaseMessaging.getToken();
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FOREGROUND");
        extractBadgeFromNotification(message);
      },
    );

    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (RemoteMessage message) {
    //     print("OPEN APP");
    //     print(message.toMap());
    //   },
    // );
  }

  void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      final int? badge = extractBadgeFromNotification(message);

      print("badge is $badge");
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
            sound: RawResourceAndroidNotificationSound(soundPath),
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
            sound: soundPath,
            badgeNumber: badge,
          ),
        ),
      );
    }
  }

  /// MARK Send
  Future<void> pushPostNotification({
    required List<String> tokens,
    required NotificationType type,
    int? badgeNumber,
  }) async {
    final Map<String, dynamic> data = {
      "fcmToken": tokens,
      "title": type.title,
      "body": type.content,
      "badge": badgeNumber,
      "sound": soundPath,
    };
    final res = await _notificationAPI.sendNotification(data);

    print("Push Notification! ${tokens.length}");

    print(res.toString());
  }

  int? extractBadgeFromNotification(RemoteMessage message) {
    // notificaton から badge の抽出
    if (message.data["badge"] != null) {
      final int badge = int.parse(message.data["badge"]);

      currentBadge = badge;
      return badge;
    } else {
      return null;
    }
  }

  void _updateBadges() {
    if (!canBadge) return;

    currentBadge > 0
        ? FlutterAppBadger.updateBadgeCount(currentBadge)
        : FlutterAppBadger.removeBadge();

    print("バッチは $currentBadge");
  }
}


    // final Map<String, dynamic> data = {
    //   "registration_ids": tokens,
    //   "notification": {
    //     "title": type.title,
    //     "body": type.content,
    //     "content_available": true,
    //     "priority": "high",
    //     "sound": soundPath,
    //     "badge": badgeNumber,
    //     "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //   },
    //   "apns": {
    //     "payload": {
    //       "aps": {
    //         "sound": soundPath,
    //       }
    //     },
    //   },
    //   "data": {
    //     // Passできる値
    //     "priority": "high",
    //     "sound": soundPath,
    //     "content_available": true,
    //     "bodyText": type.content,
    //     "badge": badgeNumber,
    //   }
    // };