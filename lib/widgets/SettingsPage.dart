import 'dart:ui';

import 'package:card_loader/blocs/settings_bloc.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsBloc bloc;

  SettingsPage({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(
                    Icons.person_pin,
                    size: 50,
                  ),
                  title: Text('Profile Details'),
                  subtitle: Text('Card number and personal details.'),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('UPDATE'),
                      onPressed: () {
                        /* ... */
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        FutureBuilder<List<ProviderAvailability>>(
          future: bloc.getProviders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('error loading providers:\n${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              final providerCards =
                  snapshot.data.map((provider) => buildProvider(provider)).toList();

              return Column(
                children: providerCards,
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildProvider(ProviderAvailability provider) {
    return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.album,
                size: 50,
              ),
              title: Text(provider.details.name),
              subtitle: Text(provider.details.desc),
            ),
            ButtonBar(children: buildProviderButtons(provider)),
          ],
        ),
      );
  }

  List<Widget> buildProviderButtons(ProviderAvailability provider) {
    if (provider.isAvailable) {
      return <Widget>[
        FlatButton(
          child: const Text('SETUP'),
          onPressed: () {
            /* ... */
          },
        ),
      ];
    } else {
      return [
        FlatButton(
          child: const Text('UPDATE'),
          onPressed: () {
            /* ... */
          },
        ),
        FlatButton(
          child: const Text('REMOVE'),
          onPressed: () {
            /* ... */
          },
        ),
      ];
    }
  }
}
