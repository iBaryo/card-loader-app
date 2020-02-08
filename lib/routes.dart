import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/widgets/ProviderPage.dart';
import 'package:card_loader/widgets/ProvidersListPage.dart';
import 'package:card_loader/widgets/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class PageDetails {
  final String title;
  final MaterialColor color;

  PageDetails(this.title, this.color);
}

class Destination {
  final PageDetails details;
  final Widget Function(Ioc ioc) widgetFactory;

  Destination(this.details, this.widgetFactory);
}

class MainRoute extends Destination {
  final int index;
  final IconData icon;

  MainRoute(this.index, PageDetails details, this.icon,
      Widget Function(Ioc ioc) widgetFactory)
      : super(details, widgetFactory);
}

List<MainRoute> getRoutes() => <MainRoute>[
      MainRoute(0,
          PageDetails('Settings', Colors.teal),
          Icons.settings,
          (Ioc ioc) => ioc.use(SettingsPage)),
      MainRoute(1,
          PageDetails('Load', Colors.red),
          Icons.send,
          (Ioc ioc) => ioc.use(ProvidersListPage)),
    ];
