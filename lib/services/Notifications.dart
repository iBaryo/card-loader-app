import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as LocalNoti;

class NotificationsService {
  int _notiId = 1;
  LocalNoti.FlutterLocalNotificationsPlugin _plugin;

  NotificationsService() {
    _plugin = LocalNoti.FlutterLocalNotificationsPlugin();

    _plugin.initialize(LocalNoti.InitializationSettings(
        LocalNoti.AndroidInitializationSettings('app_icon'),
        LocalNoti.IOSInitializationSettings()));
  }

  show(Notification notification) async {
    var platformChannelSpecifics = LocalNoti.NotificationDetails(
        LocalNoti.AndroidNotificationDetails(
            'cardLoader', 'single', 'single notifications'),
        LocalNoti.IOSNotificationDetails());
    await _plugin.show(_notiId++, notification.title, notification.body,
        platformChannelSpecifics,
        payload: notification.payload);
  }

  schedule(List<int> days, TimeOfDay time, Notification notification) {}
}

class Notification {
  String title;
  String body;
  final String payload;

  Notification(this.title, this.body) : payload = 'test';
}
