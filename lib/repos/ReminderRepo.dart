import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/repos/BaseRepo.dart';
import 'package:card_loader/services/Notifications.dart';
import 'package:card_loader/services/Storage.dart';
import 'package:flutter/material.dart' show TimeOfDay, debugPrint;

class ReminderRepo extends BaseRepo<ReminderSettings> {
  NotificationsService notifications;

  ReminderRepo({Storage storage, this.notifications}) : super(storage);

  @override
  String getStorageKey() => 'notifications';

  @override
  ReminderSettings empty() => ReminderSettings.empty();

  @override
  ReminderSettings parse(json) => ReminderSettings(
      json['days'] as int,
      TimeOfDay.fromDateTime(
          DateTime.fromMicrosecondsSinceEpoch(json['time'])));

  @override
  stringify(ReminderSettings settings) {
    final now = DateTime.now();
    return {
      'days': settings.rawDays,
      'time': DateTime(now.year, now.month, now.day, settings.time.hour,
              settings.time.minute)
          .microsecondsSinceEpoch,
    };
  }

  @override
  set(ReminderSettings settings) async {
    await notifications.clear();

    debugPrint('setting notificafions');
    await notifications.schedule(settings.getDays(), settings.time,
        Notification('Time to Load!', 'So you won\'t miss you budget!'));

    return await super.set(settings);
  }

  @override
  clear() async {
    debugPrint('clearing notificafions');
    await notifications.clear();
    return await super.clear();
  }
}
