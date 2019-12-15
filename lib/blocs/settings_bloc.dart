import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/resources/UserRepo.dart';

class SettingsBloc {
  ProvidersRepo _providersRepo;
  UserRepo _userRepo;

  SettingsBloc(ProvidersRepo providersRepo, UserRepo userRepo)
      : _providersRepo = providersRepo,
        _userRepo = userRepo;

  // todo: make the 2 below a stream?
  Future<Iterable<ProviderAvailability>> getProviders() async {
    final available = await _providersRepo.getAvailable();
    return _providersRepo.getAll().map((provider) => ProviderAvailability(
        isAvailable: available.contains(provider), provider: provider));
  }

  Future<Profile> getProfile() => _userRepo.get();

  setProfile(Profile profile) async {
    await _userRepo.set(profile);
  }
}

class ProviderAvailability {
  bool isAvailable;
  Provider provider;

  ProviderAvailability({bool isAvailable, Provider provider})
      : isAvailable = isAvailable,
        provider = provider;
}
