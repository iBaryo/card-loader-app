import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/resources/ReminderRepo.dart';
import 'package:card_loader/resources/ProfileRepo.dart';
import 'package:card_loader/routes.dart';
import 'package:day_selector/day_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePageDestination extends Destination {
  ProfilePageDestination()
      : super(
      PageDetails('Profile', Colors.cyan), (ioc) => ioc.use(ProfilePage));
}

class ProfilePage extends StatefulWidget {
  final ProfileRepo profileRepo;
  final ReminderRepo notificationsRepo;

  ProfilePage(this.profileRepo, this.notificationsRepo);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(this.profileRepo, this.notificationsRepo);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final ProfileRepo profileRepo;
//  final Future<Profile> _profile;

  bool _showNotifications;
  final ReminderRepo notificationsRepo;
//  final Future<NotificationSettings> _notiSettings;

  final Future<dynamic> _reqData;

  ProfilePageState(this.profileRepo, this.notificationsRepo)
      : _reqData =  Future.wait([
          profileRepo.get(),        // 0
          notificationsRepo.get()   // 1
  ]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: FutureBuilder(
          future: _reqData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('fuck');
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final Profile profile = snapshot.data[0] as Profile;
              final notiSettings = snapshot.data[1] as ReminderSettings;

              if (_showNotifications == null) {
                _showNotifications = notiSettings.isActive();
              }

              return Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.person),
                              hintText: 'Enter your first name',
                              labelText: 'First name',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (val) => val.isEmpty ? 'required' : null,
                            initialValue: profile.firstName,
                            onSaved: (val) => profile.firstName = val,
                          ),
                          new TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.person_outline),
                              hintText: 'Enter your last name',
                              labelText: 'Last name',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (val) => val.isEmpty ? 'required' : null,
                            initialValue: profile.lastName,
                            onSaved: (val) => profile.lastName = val,
                          ),
                          new TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.credit_card),
                              hintText: 'Enter your Cibus card number',
                              labelText: 'Card Number',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            validator: (val) => val.isEmpty ? 'required' : null,
                            initialValue: profile.card.number,
                            onSaved: (val) => profile.card.number = val,
                          ),
                          new TextFormField(
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.attach_money),
                              hintText: 'Enter your budget limit',
                              labelText: 'Credit Limit',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            validator: (val) => val.isEmpty ? 'required' : null,
                            initialValue:
                            profile.budget.settings.limit.toString(),
                            onSaved: (val) =>
                            profile.budget.settings.limit =
                                double.parse(val),
                          ),
                          Column(
                            children: <Widget>[
                              RadioListTile<BudgetFrequency>(
                                title: const Text('Daily'),
                                groupValue: profile.budget.settings.frequency,
                                value: BudgetFrequency.DAILY,
                                onChanged: (val) =>
                                    setState(() =>
                                    profile.budget.settings.frequency = val),
                              ),
                              RadioListTile<BudgetFrequency>(
                                title: const Text('Weekly'),
                                groupValue: profile.budget.settings.frequency,
                                value: BudgetFrequency.WEEKLY,
                                onChanged: (val) =>
                                    setState(() =>
                                    profile.budget.settings.frequency = val),
                              ),
                              RadioListTile<BudgetFrequency>(
                                title: const Text('Monthly'),
                                groupValue: profile.budget.settings.frequency,
                                value: BudgetFrequency.MONTHLY,
                                onChanged: (val) =>
                                    setState(() =>
                                    profile.budget.settings.frequency = val),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          CheckboxListTile(
                            title: const Text('Reminders'),
                            controlAffinity:
                            ListTileControlAffinity.leading,
                            value: _showNotifications,
                            onChanged: (value) =>
                                setState(() => _showNotifications = value),
                          ),
                          Visibility(
                            visible: _showNotifications,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                    EdgeInsets.symmetric(vertical: 10.0),
                                  child: DaySelector(
                                      value: notiSettings.rawDays,
                                      onChange: (value) => notiSettings.rawDays = value,
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
                                            final selectedTime =
                                            await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (selectedTime != null) {
                                              setState(() =>
                                              notiSettings
                                                  .time = selectedTime);
                                            }
                                          },
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(notiSettings.time
                                          .format(context)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      new Container(
                          padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                          child: new RaisedButton(
                            child: const Text('Save'),
                            onPressed: () async {
                              final FormState form = _formKey.currentState;

                              if (form.validate()) {
                                form.save();

                                if (!_showNotifications) {
                                  notiSettings.reset();
                                }

                                await profileRepo.set(profile);
                                await notificationsRepo.set(notiSettings);
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Saved')));
                              }
                            },
                          )),
                    ],
                  ));
            }
          },
        ));
  }
}
