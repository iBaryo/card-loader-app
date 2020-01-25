import 'package:card_loader/models/NotificationSettings.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/resources/NotificationsRepo.dart';
import 'package:card_loader/resources/ProfileRepo.dart';

class SettingsBloc {
  ProvidersRepo providersRepo;
  ProfileRepo profileRepo;
  NotificationsRepo notificationRepo;

  SettingsBloc({this.providersRepo, this.profileRepo, this.notificationRepo});

  // todo: make the 2 below a stream?
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

  setNotificationSettings(NotificationSettings settings) async {
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
  NotificationSettings notificationSettings;

  Settings({Profile profile, NotificationSettings notificationSettings})
      : profile = profile,
        notificationSettings = notificationSettings;
}
