import 'package:card_loader/models/DirectLoad.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/repos/ReminderRepo.dart';

class SettingsBloc {
  ProvidersRepo providersRepo;
  CardRepo cardRepo;
  ReminderRepo notificationRepo;

  SettingsBloc({this.providersRepo, this.cardRepo, this.notificationRepo});

  Future<List<ProviderAvailability>> getProviders() async {
    final configs = await providersRepo.getAllProviderData();
    final card = await cardRepo.get();
    return providersRepo
        .getAll()
        .map((provider) {
          final config = configs[provider.name];
          final noSetup = provider.requiredFields.length == 0;
          final directLoad = DirectLoad(
              config: provider.directLoad,
              card: card,
              providerFields: config
          );

          return ProviderAvailability(
            isActive: provider.isActive,
            noSetup: noSetup,
            isConfigured: noSetup || config != null,
            supportDirectLoad: directLoad.config != null,
            isDirectLoadConfigured: directLoad.isActive(),
            details: provider);
        })
        .toList();
  }
}

class ProviderAvailability {
  bool isActive;
  bool noSetup;
  bool isConfigured;
  bool supportDirectLoad;
  bool isDirectLoadConfigured;
  ProviderDetails details;

  ProviderAvailability(
      {this.isActive,
      this.noSetup,
      this.isConfigured,
      this.details,
      this.supportDirectLoad,
      this.isDirectLoadConfigured});
}
