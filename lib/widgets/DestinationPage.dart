import 'package:card_loader/routes.dart';
import 'package:flutter/material.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({Key key, this.destination}) : super(key: key);

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.title),
        backgroundColor: destination.color,
      ),
      backgroundColor: destination.color[50],
      body: SizedBox.expand(child: destination.widget),
    );
  }
}