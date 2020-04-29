import 'package:card_loader/blocs/loader_bloc.dart';
import 'package:card_loader/blocs/provider_bloc.dart';
import 'package:card_loader/blocs/settings_bloc.dart';
import 'package:card_loader/providers.dart';
import 'package:card_loader/repos/BudgetRepo.dart';
import 'package:card_loader/repos/ReminderRepo.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/routes.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/services/MemoryStorage.dart';
import 'package:card_loader/services/NotificationHandler.dart';
import 'package:card_loader/services/Notifications.dart';
import 'package:card_loader/services/Storage.dart';
import 'package:card_loader/widgets/DestinationViewFactory.dart';
import 'package:card_loader/widgets/HomePage.dart';
import 'package:card_loader/widgets/ProfilePage.dart';
import 'package:card_loader/widgets/ProvidersListPage.dart';
import 'package:card_loader/widgets/SettingsPage.dart';
import 'package:card_loader/widgets/profile/BudgetPanel.dart';
import 'package:card_loader/widgets/profile/CardPanel.dart';
import 'package:card_loader/widgets/profile/ReminderPanel.dart';
import 'package:ioc/ioc.dart';

const ROUTES = 'routes';

Ioc setupIoc() {
  print('init ioc... ${DateTime.now().toString()}');

  final ioc = Ioc();
  ioc.bind(Ioc, (ioc) => ioc, singleton: true);

  ioc.bind(ROUTES, (ioc) => getRoutes(), singleton: true, lazy: true);

  //#region  services
  ioc.bind(Storage, (ioc) {
    print('init storage service...');
    return Storage();
  }, singleton: true);

  ioc.bind(MemoryStorage, (ioc) {
    return MemoryStorage();
  }, singleton: true);

  ioc.bind(CardLoader, (ioc) {
    print('init card loader service...');
    return CardLoader();
  }, singleton: true);

  ioc.bind(NotificationHandler, (ioc) => NotificationHandler(),
      singleton: true, lazy: true);

  ioc.bind(NotificationsService, (ioc) {
    print('init notifications service...');
    return NotificationsService(ioc.use(NotificationHandler));
  }, singleton: true, lazy: true);
  //#endregion

  //#region repos
  ioc.bind(ProvidersRepo, (ioc) {
    print('init providers repo...');
    return ProvidersRepo(
        storage: ioc.use(MemoryStorage), providers: defineProviders());
  }, singleton: true);

  ioc.bind(CardRepo, (ioc) {
    print('init card repo...');
    return CardRepo(storage: ioc.use(Storage));
  }, singleton: true);

  ioc.bind(BudgetRepo, (ioc) {
    print('init budget repo...');
    return BudgetRepo(storage: ioc.use(Storage));
  }, singleton: true);

  ioc.bind(ReminderRepo, (ioc) {
    print('init notifications repo...');
    return ReminderRepo(
        storage: ioc.use(Storage),
        notifications: ioc.use(NotificationsService));
  }, singleton: true, lazy: true);

  //#endregion

  //#region  blocs
  ioc.bind(ProviderSetupBloc,
      (ioc) => ProviderSetupBloc(repo: ioc.use(ProvidersRepo)),
      singleton: true);

  ioc.bind(
      SettingsBloc,
      (ioc) => SettingsBloc(
          cardRepo: ioc.use(CardRepo),
          providersRepo: ioc.use(ProvidersRepo),
          notificationRepo: ioc.use(ReminderRepo)),
      singleton: true,
      lazy: true);

  ioc.bind(
      CardLoaderBloc,
      (ioc) => CardLoaderBloc(
          cardRepo: ioc.use(CardRepo),
          providersRepo: ioc.use(ProvidersRepo),
          cardLoader: ioc.use(CardLoader),
          budgetRepo: ioc.use(BudgetRepo),
          notificationsService: ioc.use(NotificationsService),
          notiHandler: ioc.use(NotificationHandler)),
      singleton: true,
      lazy: true);

  //#endregion

  //#region widgets

  ioc.bind(DestinationViewFactory, (ioc) => DestinationViewFactory(ioc));

  ioc.bind(
      HomePage,
      (ioc) => HomePage(
          destFactory: ioc.use(DestinationViewFactory),
          routes: ioc.use(ROUTES)),
      singleton: true,
      lazy: true);

  ioc.bind(ProvidersListPage,
      (ioc) => ProvidersListPage(bloc: ioc.use(CardLoaderBloc)),
      lazy: true);

  ioc.bind(SettingsPage, (ioc) => SettingsPage(bloc: ioc.use(SettingsBloc)),
      lazy: true);

  ioc.bind(ReminderPanel, (ioc) => ReminderPanel(ioc.use(ReminderRepo)));
  ioc.bind(BudgetPanel, (ioc) => BudgetPanel(ioc.use(BudgetRepo)));
  ioc.bind(CardPanel, (ioc) => CardPanel(ioc.use(CardRepo)));

  ioc.bind(
      ProfilePage,
      (ioc) => ProfilePage(
            reminderPanel: ioc.use(ReminderPanel),
            budgetPanel: ioc.use(BudgetPanel),
            cardPanel: ioc.use(CardPanel),
          ),
      lazy: true);
  //#endregion

  return ioc;
}
