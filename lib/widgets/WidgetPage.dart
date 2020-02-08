import 'package:card_loader/routes.dart';
import 'package:flutter/material.dart';

class WidgetPage extends StatelessWidget {
  const WidgetPage({Key key, this.details, this.widget}) : super(key: key);

  final PageDetails details;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(details.title),
        backgroundColor: details.color,
      ),
      backgroundColor: details.color[50],
      body: SizedBox.expand(child: widget),
    );
  }
}