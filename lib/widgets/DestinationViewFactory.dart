import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/routes.dart';
import 'package:card_loader/widgets/WidgetPage.dart';
import 'package:card_loader/widgets/ProviderPage.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class DestinationViewFactory {
  final Ioc ioc;

  DestinationViewFactory(this.ioc);

  DestinationView create(
      {Key key, MainRoute destination, VoidCallback onNavigation}) {
    return DestinationView(
        ioc: ioc,
        key: key,
        destination: destination,
        onNavigation: onNavigation);
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView(
      {Key key, this.destination, this.onNavigation, this.ioc})
      : super(key: key);

  final MainRoute destination;
  final VoidCallback onNavigation;
  final Ioc ioc;

  @override
  _DestinationViewState createState() => _DestinationViewState(ioc);
}

class _DestinationViewState extends State<DestinationView> {
  final Ioc ioc;

  _DestinationViewState(this.ioc) : super();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: <NavigatorObserver>[
        ViewNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            final destination = getDestination(settings);
            return WidgetPage(
              details: destination.details,
              widget: destination.widgetFactory(ioc),
            );
          },
        );
      },
    );
  }

  Destination getDestination(RouteSettings settings) {
    switch (settings.name) {
      case 'profile':
        return null;
      case 'provider':
        return ProviderDestination(settings.arguments as ProviderDetails);
      default:
        return widget.destination;
    }
  }
}


class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}