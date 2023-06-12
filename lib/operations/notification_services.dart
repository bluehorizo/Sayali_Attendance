import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:googlesheet/model/attendancemodel.dart';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googlesheet/pages/homepage.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print(" Already Notification permission Accepted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Please allow Notification permission");
    } else {
      AppSettings.openNotificationSettings();
      print("User Denied permission");
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage remoteMessage) async {
    var androidNotification =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iphoneNotification = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidNotification, iOS: iphoneNotification);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, remoteMessage);
    });
  }

  Future<String> getDeviceTaken() async {
    String? token = await messaging.getToken();
    print('Device Token:- $token');
    return token!;
  }

  void notificationSend(
      AttendanceModel attendanceModel, bool isInTime, String token) {
    var targetOrCompletion = attendanceModel.target;
    var title = "";

    if (isInTime) {
      targetOrCompletion = 'Target ${attendanceModel.target}';
      title = '${attendanceModel.name} Sign In Now';
    } else {
      targetOrCompletion = 'Completion ${attendanceModel.completion}';
      title = '${attendanceModel.name} Sign Out Now';
    }
    getDeviceTaken().then((value) async {
      var data = {
        'to': token,
        'priority': 'high',
        'notification': {'title': title, 'body': targetOrCompletion},
        'data': {
          'type': 'aaj',
          'id': 'asif1245',
        }
      };
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(data),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAGTe9G7c:APA91bFlJzXuo9ylBPDGEeIyWuSju4ID2PzXZAaMAL1Uhm4QVXomldJMMFYof2iPv-W0kkEMcr9xxHZNRhKOgaHn82ZzGpjorKPD8DwNlrFli4qIAVW5bRRJv-x15IKx2BK070yNwUxP'
          });
    });
  }

  void isRefresh() {
    messaging.onTokenRefresh.listen((event) {
     
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    String groupKey = 'groupkey101';
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
        importance: Importance.max);
    AndroidNotificationDetails androidNotification = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Your Channel Description",
      groupKey: 'group_key',
      setAsGroupSummary: true,
      priority: Priority.high,
      ticker: 'ticker',
      importance: Importance.high,
      styleInformation: BigTextStyleInformation(''),
      playSound: true,
      enableVibration: true,
      color: Colors.green,
    );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotification, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          Random.secure().nextInt(100000),
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(context, event);
      });
    }
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == "aaj") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
