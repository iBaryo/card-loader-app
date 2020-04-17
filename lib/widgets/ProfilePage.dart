import 'package:card_loader/models/Budget.dart';
import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/repos/ReminderRepo.dart';
import 'package:card_loader/repos/ProfileRepo.dart';
import 'package:card_loader/routes.dart';
import 'package:day_selector/day_selector.dart';
import 'package:flutter/cupertino.dart';
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

class ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final ProfileRepo profileRepo;
  final ReminderRepo notificationsRepo;
  final Future<List<dynamic>> _reqData;

  bool _showReminderSettings;
  bool _showBudgetSettings;
  bool _showDirectLoadSettings;

  ProfilePageState(this.profileRepo, this.notificationsRepo)
      : _reqData = Future.wait([
          profileRepo.get(), // 0
          notificationsRepo.get() // 1   // TODO: why not bloc?
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

              return Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new ListView(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16.0),
                    children: [
                      ExpansionPanelList(
                        expansionCallback: (i, isExpanded) => setState(() {
                          switch (i) {
                            case 0:
                              _showReminderSettings = !isExpanded;
                              break;
                            case 1:
                              _showBudgetSettings = !isExpanded;
                              break;
                            case 2:
                              _showDirectLoadSettings = !isExpanded;
                              break;
                          }
                        }),
                        children: [
                          getReminderPanel(notiSettings),
                          getBudgetPanel(profile.budget),
                          getCardPanel(profile.card),
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
                                await profileRepo.set(profile);

                                if (!_showReminderSettings) {
                                  await notificationsRepo.clear();
                                } else {
                                  await notificationsRepo.set(notiSettings);
                                }

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

  bool _reminderEnabled;

  ExpansionPanel getReminderPanel(ReminderSettings notiSettings) {
    if (_reminderEnabled == null) {
      _reminderEnabled = notiSettings.isActive();
    }

    if (_showReminderSettings == null) {
      _showReminderSettings = _reminderEnabled;
    }

    return ExpansionPanel(
        isExpanded: _showReminderSettings || _reminderEnabled,
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) => SwitchListTile(
              title: const Text('Reminders'),
              subtitle: isExpanded
                  ? Text('Get reminder notifications to use your budget.')
                  : null,
              value: _reminderEnabled,
              onChanged: (value) => setState(() => _reminderEnabled = value),
            ),
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
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
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (selectedTime != null) {
                            setState(() => notiSettings.time = selectedTime);
                          }
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(notiSettings.time.format(context)),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  bool _budgetManagementEnabled;

  ExpansionPanel getBudgetPanel(Budget budget) {
    final settings = budget.settings;
    if (_budgetManagementEnabled == null) {
      _budgetManagementEnabled = settings?.isConfigured() ?? false;
    }

    if (_showBudgetSettings == null) {
      _showBudgetSettings = _budgetManagementEnabled;
    }

    return ExpansionPanel(
        isExpanded: _showBudgetSettings || _budgetManagementEnabled,
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) => SwitchListTile(
              title: const Text('Budget Management'),
              subtitle: isExpanded
                  ? Text(
                      'Help you manage your budget so you can get the best of it')
                  : null,
              value: _budgetManagementEnabled,
              onChanged: (value) =>
                  setState(() => _budgetManagementEnabled = value),
            ),
        body: Column(
          children: [
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
              initialValue: settings.limit.toString(),
              onSaved: (val) => settings.limit = double.parse(val),
            ),
            Column(
              children: <Widget>[
                RadioListTile<BudgetFrequency>(
                  title: const Text('Daily'),
                  groupValue: settings.frequency,
                  value: BudgetFrequency.DAILY,
                  onChanged: (val) => setState(() => settings.frequency = val),
                ),
                RadioListTile<BudgetFrequency>(
                  title: const Text('Weekly'),
                  groupValue: settings.frequency,
                  value: BudgetFrequency.WEEKLY,
                  onChanged: (val) => setState(() => settings.frequency = val),
                ),
                RadioListTile<BudgetFrequency>(
                  title: const Text('Monthly'),
                  groupValue: settings.frequency,
                  value: BudgetFrequency.MONTHLY,
                  onChanged: (val) => setState(() => settings.frequency = val),
                ),
              ],
            ),
          ],
        ));
  }

  bool _directLoadEnabled;

  ExpansionPanel getCardPanel(CompanyCard card) {
    if (_directLoadEnabled == null) {
      _directLoadEnabled = card.isActive();
    }

    if (_showDirectLoadSettings == null) {
      _showDirectLoadSettings = _directLoadEnabled;
    }

    return ExpansionPanel(
        isExpanded: _showDirectLoadSettings || _directLoadEnabled,
        canTapOnHeader: true,
        headerBuilder: (context, isExpanded) => SwitchListTile(
              title: const Text('Direct Load'),
              subtitle: isExpanded
                  ? Text('Details to enable direct usage of your budget.')
                  : null,
              value: _directLoadEnabled,
              onChanged: (value) => setState(() => _directLoadEnabled = value),
            ),
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: Column(
            children: <Widget>[
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your first name',
                  labelText: 'First name',
                ),
                keyboardType: TextInputType.text,
                validator: (val) => val.isEmpty ? 'required' : null,
                initialValue: card.firstName,
                onSaved: (val) => card.firstName = val,
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person_outline),
                  hintText: 'Enter your last name',
                  labelText: 'Last name',
                ),
                keyboardType: TextInputType.text,
                validator: (val) => val.isEmpty ? 'required' : null,
                initialValue: card.lastName,
                onSaved: (val) => card.lastName = val,
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
                initialValue: card.number,
                onSaved: (val) => card.number = val,
              ),
            ],
          ),
        )
    );
  }
}
