import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/services/Storage.dart';
import 'package:flutter/material.dart';

const STORAGE_KEY = 'notifications';

class ReminderRepo {
  Storage _storage;

  ReminderRepo(this._storage);

  Future<ReminderSettings> get() async {
    final notiJson = await _storage.get(STORAGE_KEY);
    if (notiJson == null) {
      return ReminderSettings.empty();
    }

    try {
      return ReminderSettings(
              notiJson['days'] as int,
              TimeOfDay.fromDateTime(
                  DateTime.fromMicrosecondsSinceEpoch(notiJson['time'])
              )
          );
    } catch (e) {
      print('error parsing noti settings');
      print(e);
      return ReminderSettings.empty();
    }
  }

  set(ReminderSettings settings) async {
    final now = DateTime.now();
    _storage.set(STORAGE_KEY, {
      'days': settings.rawDays,
      'time': DateTime(now.year, now.month, now.day, settings.time.hour,
              settings.time.minute).microsecondsSinceEpoch,
    });
  }
}
