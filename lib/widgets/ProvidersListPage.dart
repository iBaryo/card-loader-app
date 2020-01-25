import 'package:card_loader/blocs/loader_bloc.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:flutter/material.dart';

class ProvidersListPage extends StatelessWidget {
  final CardLoaderBloc bloc;

  ProvidersListPage({this.bloc});

  @override
  Widget build(BuildContext context) {
    bloc.fetchProviders();
    return FutureBuilder(
      future: bloc.hasRequiredInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return buildError(snapshot.error);
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        else if (!snapshot.data) {
          return buildMessage('Missing required settings');
        }
        else {
          return StreamBuilder(
            stream: bloc.availableProviders$,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot.data as List<ProviderDetails>);
              } else if (snapshot.hasError) {
                return buildError(snapshot.error);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      },
    );
  }

  Widget buildList(List<ProviderDetails> providers) {
    if (providers.length == 0) {
      return buildMessage('No configured providers');
    } else {
      return Text(
        'LIST',
      );
    }
  }

  Widget buildError(Object error) {
    return Text(
      error.toString(),
    );
  }

  Widget buildMessage(String msg) {
    return Center(
        child: Text(
          msg,
          style: TextStyle(fontSize: 25),
        ));
  }
}
