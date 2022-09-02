import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getx_near/main.dart';
import 'package:getx_near/src/api/notification_api.dart';
import 'package:getx_near/src/api/recent_api.dart';

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
  final RecentAPI _recentAPI = RecentAPI();

  @override
  void onInit() async {
    super.onInit();
    listenForeground();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String get soundPath {
    // iOS only accepts .wav, .aiff, and .caf extensions
    // Android only accepts .wav, .mp3 and .ogg extensions
    return Platform.isIOS ? "help.caf" : "help.wav";
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
    if (isRealDevice) print(await _firebaseMessaging.getAPNSToken());
    return await _firebaseMessaging.getToken();
  }

  void listenForeground() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("FOREGROUND");
        // showNotification(message);
      },
    );
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
            sound: RawResourceAndroidNotificationSound(soundPath),
          ),
          iOS: IOSNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentAlert: true,
            sound: soundPath,
          ),
        ),
      );
    }
  }

  /// MARK Send
  Future<void> pushPostNotification({
    required List<String> tokens,
    required NotificationType type,
  }) async {
    final Map<String, dynamic> data = {
      "registration_ids": tokens,
      "notification": {
        "Title": type.title,
        "body": type.content,
        "content_available": true,
        "priority": "high",
        "sound": soundPath,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      },
      "apns": {
        "payload": {
          "aps": {
            "sound": soundPath,
          }
        }
      },
      "data": {
        "priority": "high",
        "sound": soundPath,
        "content_available": true,
        "bodyText": type.content,
      }
    };

    final res = await _notificationAPI.sendNotification(data);

    print("Push Notification! ${tokens.length}");

    print(res.toString());
  }

  Future<int> _getBadges() async {
    // if (!canBadge) return 0;
    final res = await _recentAPI.getBadgeCount();
    if (!res.status) {
      print("バッジの獲得不可");
      return 0;
    }

    int badgeCount = res.data;
    return badgeCount;
  }

  Future<void> updateBadges() async {
    print('Background');

    try {
      int badgeCount = await _getBadges();
      print(badgeCount);
      if (badgeCount > 0) {
        if (badgeCount > 99) badgeCount = 99;

        FlutterAppBadger.updateBadgeCount(badgeCount);
      } else {
        FlutterAppBadger.removeBadge();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
