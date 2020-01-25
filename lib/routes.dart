import 'package:card_loader/widgets/ProvidersListPage.dart';
import 'package:card_loader/widgets/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class Destination {
  Destination(this.index, this.title, this.icon, this.color, this.widget);

  final int index;
  final String title;
  final IconData icon;
  final MaterialColor color;
  final Widget widget;
}

List<Destination> getRoutes(Ioc ioc) => <Destination>[
      Destination(
          0, 'Settings', Icons.settings, Colors.teal, ioc.use(SettingsPage)),
      Destination(1, 'Load', Icons.send, Colors.red, ioc.use(ProvidersListPage)),
    ];
