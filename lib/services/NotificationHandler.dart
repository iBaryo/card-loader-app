import 'package:card_loader/blocs/loader_bloc.dart';

enum NotificationType {
  Load,
  UseBudget,
}

class NotificationHandler {
  final Map<NotificationType, Future<dynamic> Function()> handlers;

  NotificationHandler(CardLoaderBloc cardLoaderBloc)
      : handlers = {
          NotificationType.Load: () =>
              cardLoaderBloc.loadDailyBudgetToDefaultProvider(),
          NotificationType.UseBudget: () async {/*TODO*/},
        };

  Future<dynamic> handle(NotificationType notiType) =>
      handlers.containsKey(notiType) ? handlers[notiType]() : null;
}
