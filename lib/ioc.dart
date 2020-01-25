import 'package:card_loader/blocs/loader_bloc.dart';
import 'package:card_loader/blocs/provider_bloc.dart';
import 'package:card_loader/providers.dart';
import 'package:card_loader/resources/ProfileRepo.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/routes.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/services/storage.dart';
import 'package:card_loader/widgets/HomePage.dart';
import 'package:card_loader/widgets/ProvidersListPage.dart';
import 'package:card_loader/widgets/SettingsPage.dart';
import 'package:ioc/ioc.dart';

const ROUTES = 'routes';

Ioc setupIoc() {
  print('init ioc...');

  final ioc = Ioc();

  ioc.bind(ROUTES, (ioc) => getRoutes(ioc), singleton: true, lazy: true);

  //#region  services
  ioc.bind(Storage, (ioc) {
    print('init storage service...');
    return Storage();
  }, singleton: true);

  ioc.bind(CardLoader, (ioc) {
    print('init card loader service...');
    return CardLoader();
  }, singleton: true);
  //#endregion

  //#region repos
  ioc.bind(ProvidersRepo, (ioc) {
    print('init providers repo...');
    return ProvidersRepo(
        storage: ioc.use(Storage), providers: defineProviders());
  }, singleton: true);

  ioc.bind(ProfileRepo, (ioc) {
    print('init profile repo...');
    return ProfileRepo(storage: ioc.use(Storage));
  }, singleton: true);

  //#endregion

  //#region  blocs
  ioc.bind(ProviderSetupBloc, (ioc) => ProviderSetupBloc(repo: ioc.use(ProvidersRepo)), singleton: true);

  ioc.bind(CardLoaderBloc, (ioc) => CardLoaderBloc(
      profileRepo: ioc.use(ProfileRepo),
      providersRepo: ioc.use(ProvidersRepo),
      cardLoader: ioc.use(CardLoader)
    ), singleton: true);

  //#endregion

  //#region widgets
  ioc.bind(HomePage, (ioc) => HomePage(routes: ioc.use(ROUTES)), singleton: true, lazy: true);

  ioc.bind(ProvidersListPage, (ioc) => ProvidersListPage(bloc: ioc.use(CardLoaderBloc)), lazy: true);

  ioc.bind(SettingsPage, (ioc) => SettingsPage(), lazy: true);
  //#endregion

  return ioc;
}
