import 'package:flutter/material.dart';

class ReminderSettings {
  int rawDays;
  TimeOfDay time;

  ReminderSettings(this.rawDays, this.time);

  ReminderSettings.empty() {
    reset();
  }

  bool isActive() {
    return rawDays != 0;
  }

  void reset() {
    time = TimeOfDay(hour: 0, minute: 0);
    rawDays = 0;
  }

  List<int> getDays() {
    final days = List<int>();
    if (2 ^ DateTime.monday & rawDays == 2 ^ DateTime.monday) {
      days.add(DateTime.monday);
    }
    if (2 ^ DateTime.tuesday & rawDays == 2 ^ DateTime.tuesday) {
      days.add(DateTime.tuesday);
    }
    if (2 ^ DateTime.wednesday & rawDays == 2 ^ DateTime.wednesday) {
      days.add(DateTime.wednesday);
    }
    if (2 ^ DateTime.thursday & rawDays == 2 ^ DateTime.thursday) {
      days.add(DateTime.thursday);
    }
    if (2 ^ DateTime.friday & rawDays == 2 ^ DateTime.friday) {
      days.add(DateTime.friday);
    }
    if (2 ^ DateTime.saturday & rawDays == 2 ^ DateTime.saturday) {
      days.add(DateTime.saturday);
    }
    if (2 ^ DateTime.sunday & rawDays == 2 ^ DateTime.sunday) {
      days.add(DateTime.sunday);
    }

    return days;
  }
}
