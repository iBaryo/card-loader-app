import 'dart:math';

import 'package:card_loader/models/IActive.dart';
import 'package:flutter/material.dart';

class ReminderSettings implements IActive {
  int rawDays;
  TimeOfDay time;

  ReminderSettings(this.rawDays, this.time);

  ReminderSettings.empty() {
    reset();
  }

  bool isActive() => rawDays != 0;

  void reset() {
    time = TimeOfDay(hour: 0, minute: 0);
    rawDays = 0;
  }

  List<int> getDays() {
    final days = List<int>();
    if (hasDay(DateTime.monday)) {
      days.add(DateTime.monday);
    }
    if (hasDay(DateTime.tuesday)) {
      days.add(DateTime.tuesday);
    }
    if (hasDay(DateTime.wednesday)) {
      days.add(DateTime.wednesday);
    }
    if (hasDay(DateTime.thursday)) {
      days.add(DateTime.thursday);
    }
    if (hasDay(DateTime.friday)) {
      days.add(DateTime.friday);
    }
    if (hasDay(DateTime.saturday)) {
      days.add(DateTime.saturday);
    }
    if (hasDay(DateTime.sunday)) {
      days.add(DateTime.sunday);
    }

    return days;
  }

  bool hasDay(int rawDay) {
    final day = pow(2, rawDay).toInt();
    return (day & rawDays != 0);
  }
}
