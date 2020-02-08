import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/widgets/ProviderPage.dart';
import 'package:card_loader/widgets/ProvidersListPage.dart';
import 'package:card_loader/widgets/SettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class Destination {
  final String title;
  final MaterialColor color;
  final Widget Function(Ioc ioc) widgetFactory;

  Destination(this.title, this.color, this.widgetFactory);
}

class ProviderDestination extends Destination {
  ProviderDestination(ProviderDetails provider)
      : super(provider.name, provider.color, (ioc) => ProviderPage(provider));
}

class MainRoute extends Destination {
  final int index;
  final IconData icon;

  MainRoute(this.index, title, this.icon, color, Widget Function(Ioc ioc) widgetFactory)
      : super(title, color, widgetFactory);
}

List<MainRoute> getRoutes() =>
    <MainRoute>[
      MainRoute(0, 'Settings', Icons.settings, Colors.teal,
              (Ioc ioc) => ioc.use(SettingsPage)),
      MainRoute(1, 'Load', Icons.send, Colors.red,
              (Ioc ioc) => ioc.use(ProvidersListPage)),
    ];
