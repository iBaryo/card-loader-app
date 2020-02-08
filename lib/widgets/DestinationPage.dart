import 'package:card_loader/routes.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({Key key, this.destination, this.ioc}) : super(key: key);

  final Destination destination;
  final Ioc ioc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: SizedBox.expand(child: destination.widgetFactory(ioc)),
    );
  }
}