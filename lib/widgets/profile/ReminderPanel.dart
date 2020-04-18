import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/repos/ReminderRepo.dart';
import 'package:card_loader/widgets/profile/BasePanel.dart';
import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';

class ReminderPanel extends BasePanel<ReminderSettings> {
  ReminderPanel(ReminderRepo reminderRepo): super(reminderRepo);

  @override
  String getTitleText() => 'Reminders';

  @override
  String getSubTitleText() => 'Get reminder notifications to use your budget.';

  @override
  Widget getBody(BuildContext context, ReminderSettings settings,
      void Function(VoidCallback cb) invokeChange) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: DaySelector(
              value: settings.rawDays,
              onChange: (value) {
                onModelChange(
                    settings, (model) => model.rawDays = value, invokeChange);
              },
              color: Colors.white,
              mode: DaySelector.modeFull),
        ),
        Row(
          children: <Widget>[
            Ink(
                height: 40.0,
                decoration: const ShapeDecoration(
                  color: Colors.lightBlue,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.alarm),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      onModelChange(settings,
                          (settings) => settings.time = selectedTime, invokeChange);
                    }
                  },
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(settings.time.format(context)),
            ),
          ],
        )
      ],
    );
  }
}
