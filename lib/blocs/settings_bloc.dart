import 'package:card_loader/models/ReminderSettings.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/repos/ReminderRepo.dart';
import 'package:card_loader/repos/ProfileRepo.dart';

class SettingsBloc {
  ProvidersRepo providersRepo;
  ProfileRepo profileRepo;
  ReminderRepo notificationRepo;

  SettingsBloc({this.providersRepo, this.profileRepo, this.notificationRepo});

  Future<List<ProviderAvailability>> getProviders() async {
    final configured = await providersRepo.getConfigured();
    return providersRepo
        .getAll()
        .map((provider) => ProviderAvailability(
            isActive: provider.isActive,
            noSetup: provider.requiredFields.length == 0,
            isConfigured: configured.contains(provider) || provider.requiredFields.length == 0,
            details: provider))
        .toList();
  }
}

class ProviderAvailability {
  bool isActive;
  bool noSetup;
  bool isConfigured;
  ProviderDetails details;

  ProviderAvailability({this.isActive, this.noSetup, this.isConfigured, this.details});
}

class Settings {
  Profile profile;
  ReminderSettings notificationSettings;

  Settings({Profile profile, ReminderSettings notificationSettings})
      : profile = profile,
        notificationSettings = notificationSettings;
}
