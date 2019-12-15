import 'package:card_loader/models/NotificationSettings.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/resources/NotificationsRepo.dart';
import 'package:card_loader/resources/ProfileRepo.dart';

class SettingsBloc {
  ProvidersRepo _providersRepo;
  ProfileRepo _userRepo;
  NotificationsRepo _notificationSettings;

  SettingsBloc(ProvidersRepo providersRepo, ProfileRepo userRepo,
      NotificationsRepo notificationSettings)
      : _providersRepo = providersRepo,
        _userRepo = userRepo,
        _notificationSettings = notificationSettings;

  // todo: make the 2 below a stream?
  Future<Iterable<ProviderAvailability>> getProviders() async {
    final available = await _providersRepo.getAvailable();
    return _providersRepo.getAll().map((provider) => ProviderAvailability(
        isAvailable: available.contains(provider), provider: provider));
  }

  Future<Settings> getSettings() async => Settings(
      profile: await _userRepo.get(),
      notificationSettings: await _notificationSettings.get());

  setProfile(Profile profile) async {
    await _userRepo.set(profile);
  }

  setNotificationSettings(NotificationSettings settings) async {
    await _notificationSettings.set(settings);
  }
}

class ProviderAvailability {
  bool isAvailable;
  Provider provider;

  ProviderAvailability({bool isAvailable, Provider provider})
      : isAvailable = isAvailable,
        provider = provider;
}

class Settings {
  Profile profile;
  NotificationSettings notificationSettings;

  Settings({Profile profile, NotificationSettings notificationSettings})
      : profile = profile,
        notificationSettings = notificationSettings;
}
