import 'package:rxdart/rxdart.dart';

enum NotificationType {
  Load,
  UseBudget,
}

class NotificationHandler {
  final Map<NotificationType, BehaviorSubject> handlers;

  NotificationHandler()
      : handlers = {
          NotificationType.Load: BehaviorSubject(),
          NotificationType.UseBudget: BehaviorSubject(),
        };

  handle(NotificationType notiType) => handlers[notiType].publish();

  register(NotificationType notiType, Future<dynamic> Function() handler) =>
      handlers[notiType].add(handler);
}
