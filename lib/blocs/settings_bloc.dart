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
    final available = await providersRepo.getAvailable();
    return providersRepo
        .getAll()
        .map((provider) => ProviderAvailability(
            isConfigured: available.contains(provider), details: provider))
        .toList();
  }

  Future<Settings> getSettings() async => Settings(
      profile: await profileRepo.get(),
      notificationSettings: await notificationRepo.get());

  setProfile(Profile profile) async {
    await profileRepo.set(profile);
  }

  setNotificationSettings(ReminderSettings settings) async {
    await notificationRepo.set(settings);
  }
}

class ProviderAvailability {
  bool isConfigured;
  ProviderDetails details;

  ProviderAvailability({this.isConfigured, this.details});
}

class Settings {
  Profile profile;
  ReminderSettings notificationSettings;

  Settings({Profile profile, ReminderSettings notificationSettings})
      : profile = profile,
        notificationSettings = notificationSettings;
}
