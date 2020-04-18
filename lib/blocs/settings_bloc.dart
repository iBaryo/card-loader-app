import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/repos/ReminderRepo.dart';

class SettingsBloc {
  ProvidersRepo providersRepo;
  CardRepo profileRepo;
  ReminderRepo notificationRepo;

  SettingsBloc({this.providersRepo, this.profileRepo, this.notificationRepo});

  Future<List<ProviderAvailability>> getProviders() async {
    final configured = await providersRepo.getConfigured();
    return providersRepo
        .getAll()
        .map((provider) => ProviderAvailability(
            isActive: provider.isActive,
            noSetup: provider.requiredFields.length == 0,
            isConfigured: configured.contains(provider) ||
                provider.requiredFields.length == 0,
            details: provider))
        .toList();
  }
}

class ProviderAvailability {
  bool isActive;
  bool noSetup;
  bool isConfigured;
  ProviderDetails details;

  ProviderAvailability(
      {this.isActive, this.noSetup, this.isConfigured, this.details});
}
