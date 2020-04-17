import 'dart:ui';
import 'package:card_loader/blocs/settings_bloc.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsBloc bloc;
  Future Function(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) navigate;

  SettingsPage({this.bloc, this.navigate = Navigator.pushNamed});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                        navigate(context, 'profile');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 5),
        FutureBuilder<List<ProviderAvailability>>(
          future: bloc.getProviders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('error loading providers:\n${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                  children: snapshot.data
                      .map((provider) => buildProvider(context, provider))
                      .toList()
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildProvider(BuildContext context, ProviderAvailability provider) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              leading: Container(
                  width: 60,
                  height: 60,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage(
                          provider.details.icon
                      ),
                      fit: BoxFit.cover,
                    ),
                  )),
              title: Text(provider.details.name),
              subtitle: Text(provider.details.desc),
              trailing: Visibility(
                  visible: provider.isActive,
                  child: provider.isConfigured
                      ? Icon(Icons.assignment_turned_in,
                          color: Colors.green, size: 30)
                      : Icon(Icons.timelapse, color: Colors.grey, size: 30))),
          ButtonBar(children: buildProviderButtons(context, provider)),
        ],
      ),
    );
  }

  List<Widget> buildProviderButtons(
      BuildContext context, ProviderAvailability provider) {
    if (!provider.isActive) {
      return [Text('Coming soon...')];
    } else if (provider.noSetup || !provider.isConfigured) {
      return [
        FlatButton(
          child: const Text('DETAILS'),
          onPressed: () async {
            navigate(context, 'provider', arguments: provider.details);
          },
        ),
      ];
    } else {
      return [
        FlatButton(
          child: Text('REMOVE', style: TextStyle(color: Colors.red)),
          onPressed: () {
            /* ... */
          },
        ),
        FlatButton(
          child: const Text('UPDATE'),
          onPressed: () {
            /* ... */
          },
        ),
      ];
    }
  }
}
