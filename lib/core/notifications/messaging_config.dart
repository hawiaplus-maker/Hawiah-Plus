import 'dart:convert';
import 'dart:developer';
import 'dart:io'; // تم إضافة هذا الاستيراد

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/layout/presentation/layout_methouds.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

@pragma('vm:entry-point')
final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// تم إزالة late لتجنب الـ Initialization Error واستخدامها بشكل أمن
GlobalKey<NavigatorState>? navigatorKey;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _showLocalNotification(message);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  if (details.payload != null) {
    try {
      final data = jsonDecode(details.payload!);
      handleNotificationTap(data);
    } catch (e) {
      log('Error decoding background notification payload: $e');
    }
  }
}

// ================= Notification Types =================

enum NotificationType { trackOrder, general }

class NotificationData {
  final NotificationType type;
  final int? orderId;

  NotificationData._({required this.type, this.orderId});

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    switch (map['notification_type'] as String?) {
      case '1':
        return NotificationData._(
          type: NotificationType.trackOrder,
          orderId: int.tryParse(map['order_id']?.toString() ?? ''),
        );
      case 'general_notifications':
        return NotificationData._(type: NotificationType.general);
      default:
        return NotificationData._(type: NotificationType.general);
    }
  }
}

// ================= Local Notification =================

Future<void> _showLocalNotification(RemoteMessage message) async {
  final notification = message.notification;
  final payload = jsonEncode(message.data);

  if (notification != null) {
    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'high_importance',
          'High Importance',
          channelDescription: 'Important notifications',
          importance: Importance.max,
          priority: Priority.high,
          // تم تغيير اسم الأيقونة هنا ليطابق إعداداتك الجديدة
          icon: '@mipmap/launcher_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}

// ================= Navigation =================

void handleNotificationTap(Map<String, dynamic> data) {
  log('Handling notification tap with data: $data');
  try {
    final notificationData = NotificationData.fromMap(data);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey == null || navigatorKey?.currentContext == null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _performNavigation(notificationData);
        });
      } else {
        _performNavigation(notificationData);
      }
    });
  } catch (e) {
    log('Error handling notification tap: $e');
  }
}

void _performNavigation(NotificationData data) async {
  final ctx = navigatorKey?.currentContext;
  if (ctx != null && ctx.mounted) {
    try {
      await LayoutMethouds.getdata();
      NavigatorMethods.pushNamed(
        ctx,
        LayoutScreen.routeName,
      );
    } catch (e) {
      log('Navigation error: $e');
    }
  } else {
    log('Navigation failed: Context is null or not mounted');
  }
}

// ================= Messaging Service =================

class MessagingService {
  MessagingService._();

  static Future<RemoteMessage?> init({
    required GlobalKey<NavigatorState> navKey,
  }) async {
    navigatorKey = navKey;

    await Firebase.initializeApp();

    // 🔥 الحل: استخدم Platform.isIOS بدلاً من Theme.of(context)
    if (Platform.isIOS) {
      await _waitForApnsToken();
    }

    // احصل على FCM Token
    final fcmToken = await _firebaseMessaging.getToken();
    log('📲 FCM Token: $fcmToken');

    await _createAndroidChannel();

    await _firebaseMessaging.subscribeToTopic('general_notifications');

    await _localNotifications.initialize(
      const InitializationSettings(
        // تم تغيير اسم الأيقونة هنا أيضاً
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          handleNotificationTap(jsonDecode(details.payload!));
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('🔐 Permission status: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (msg) => handleNotificationTap(msg.data),
    );

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationTap(initialMessage.data);
    }

    return initialMessage;
  }

  // ================= APNs Fix =================

  static Future<void> _waitForApnsToken() async {
    String? apnsToken;
    for (int i = 0; i < 10; i++) {
      apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        log('🍏 APNs Token: $apnsToken');
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    if (apnsToken == null) {
      log('⚠️ APNs token not received - push might not work on iOS real device');
    }
  }

  // ================= Android Channel =================

  static Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance',
      'High Importance',
      description: 'Important notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
