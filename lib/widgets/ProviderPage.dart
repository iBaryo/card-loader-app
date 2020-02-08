import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/routes.dart';
import 'package:flutter/material.dart';

class ProviderDestination extends Destination {
  ProviderDestination(ProviderDetails provider)
      : super(PageDetails(provider.name, provider.color), (ioc) => ProviderPage(provider));
}

class ProviderPage extends StatelessWidget {
  final ProviderDetails provider;

  ProviderPage(this.provider);

  @override
  Widget build(BuildContext context) {
    return Text('hello');
  }
}
