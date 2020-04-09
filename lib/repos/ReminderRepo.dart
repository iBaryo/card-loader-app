import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/services/Notifications.dart';
import 'package:card_loader/services/Storage.dart';
import 'package:flutter/material.dart' show TimeOfDay;

const STORAGE_KEY = 'notifications';

class ReminderRepo {
  Storage _storage;
  NotificationsService _notifications;

  ReminderRepo(this._storage, this._notifications);

  Future<ReminderSettings> get() async {
    final notiJson = await _storage.get(STORAGE_KEY);
    if (notiJson == null) {
      return ReminderSettings.empty();
    }

    try {
      return ReminderSettings(
          notiJson['days'] as int,
          TimeOfDay.fromDateTime(
              DateTime.fromMicrosecondsSinceEpoch(notiJson['time'])));
    } catch (e) {
      print('error parsing noti settings');
      print(e);
      return ReminderSettings.empty();
    }
  }

  set(ReminderSettings settings) async {
    await _notifications.clear();
    await _notifications.schedule(
        settings.getDays(),
        settings.time,
        Notification('Time to Load!', 'So you won\'t miss you budget!'));

    final now = DateTime.now();
    await _storage.set(STORAGE_KEY, {
      'days': settings.rawDays,
      'time': DateTime(now.year, now.month, now.day, settings.time.hour,
              settings.time.minute)
          .microsecondsSinceEpoch,
    });

    await _notifications
        .show(Notification('Reminder was set', 'see you then!'));
  }

  clear() async {
    await _notifications.clear();
    await _storage.set(STORAGE_KEY, null);
  }
}
