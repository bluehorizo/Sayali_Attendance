import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notification_service {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings =
        new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      styleInformation: BigTextStyleInformation('hh'),
    );

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    fln.show(0, title, body, not, payload: payload);
  }
}
