import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as LocalNoti;

class NotificationsService {
  int _notiId = 1;
  LocalNoti.FlutterLocalNotificationsPlugin _plugin;

  NotificationsService() {
    _plugin = LocalNoti.FlutterLocalNotificationsPlugin();

    debugPrint('init local notifications plugin...');
    _plugin.initialize(LocalNoti.InitializationSettings(
        LocalNoti.AndroidInitializationSettings('app_icon'),
        LocalNoti.IOSInitializationSettings()));
    debugPrint('done init local notifications plugin');
  }

  show(Notification notification) async {
    final platformChannelSpecifics = LocalNoti.NotificationDetails(
        LocalNoti.AndroidNotificationDetails(
            'cardLoader', 'single', 'single notifications'),
        LocalNoti.IOSNotificationDetails());
    await _plugin.show(++_notiId, notification.title, notification.body,
        platformChannelSpecifics,
        payload: notification.payload);
  }

  Future<List<int>> schedule(
      List<int> days, TimeOfDay time, Notification notification) {
    final platformChannelSpecifics = LocalNoti.NotificationDetails(
        LocalNoti.AndroidNotificationDetails(
            'cardLoader', 'scheduled', 'schedule notifications'),
        LocalNoti.IOSNotificationDetails());

    return Future.wait(days.map(toLocalNotiDay).map((day) async {
      await _plugin.showWeeklyAtDayAndTime(
          ++_notiId,
          notification.title,
          notification.body,
          day,
          LocalNoti.Time(time.hour, time.minute),
          platformChannelSpecifics);

      return _notiId;
    }));
  }

  final offSet = LocalNoti.Day.Monday.value - DateTime.monday - 1;
  LocalNoti.Day toLocalNotiDay(int day) {
    return LocalNoti.Day.values[(day + offSet) % DateTime.daysPerWeek];
  }

  Future<void> clear() {
    return _plugin.cancelAll();
  }
}

class Notification {
  String title;
  String body;
  final String payload;

  Notification(this.title, this.body) : payload = 'test';
}
