import 'package:card_loader/ioc.dart';
import 'package:card_loader/widgets/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  final ioc = setupIoc();
  runApp(MaterialApp(home: ioc.use(HomePage)));
}