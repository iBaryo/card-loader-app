import 'package:card_loader/models/CompanyCard.dart';
import 'package:card_loader/routes.dart';
import 'package:card_loader/widgets/profile/BasePanel.dart';
import 'package:card_loader/widgets/profile/BudgetPanel.dart';
import 'package:card_loader/widgets/profile/CardPanel.dart';
import 'package:card_loader/widgets/profile/ReminderPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePageDestination extends Destination {
  ProfilePageDestination()
      : super(
            PageDetails('Profile', Colors.cyan), (ioc) => ioc.use(ProfilePage));
}

class ProfilePage extends StatefulWidget {
  final ReminderPanel reminderPanel;
  final BudgetPanel budgetPanel;
  final DirectLoadPanel cardPanel;

  ProfilePage({this.reminderPanel, this.budgetPanel, this.cardPanel});

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(reminderPanel, budgetPanel, cardPanel);
  }
}

class ProfilePageState extends State<ProfilePage> {
  final List<BasePanel> panels;

  ProfilePageState(ReminderPanel reminderPanel, BudgetPanel budgetPanel,
      DirectLoadPanel cardPanel)
      : panels = [
          reminderPanel,
          budgetPanel,
//        cardPanel // -- pending full support
        ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16.0),
            children: [
              FutureBuilder(
                future: Future.wait(
                    panels.map((p) => p.getPanel(context, setState))),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    final ePanels = snapshot.data as List<ExpansionPanel>;
                    return ExpansionPanelList(
                      expansionCallback: (i, isExpanded) =>
                          setState(() => panels[i].isExpanded = !isExpanded),
                      children: ePanels,
                    );
                  }
                },
              )
            ]));
  }
}
