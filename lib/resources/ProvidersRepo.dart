import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/storage.dart';

class ProvidersRepo {
  Storage _storage;
  Map<String, Provider> _providers;
  Map<String, ProviderData> _providersData;

  ProvidersRepo(Storage storage, List<Provider> providers)
      : _storage = storage,
        _providers = Map<String, Provider>.fromIterable(providers,
            key: (provider) => provider.name, value: (provider) => provider);

  Future<ProviderLoader> createLoader(Profile profile, String providerName) async {
    final providersData = await _getProvidersData();
    if (!_providers.containsKey(providerName)
        || !providersData.containsKey(providerName)) {
      return null;
    }

    return _providers[providerName].createLoader(profile, providersData[providerName]);

  }

  Iterable<Provider> getAll() => _providers.values;

  Future<List<Provider>> getAvailable() async {
    return (await _getProvidersData()).keys.map((pName) => _providers[pName]);
  }

  Future<T> getProviderData<T extends ProviderData>(String providerName) async {
    final providers = await _getProvidersData();
    if (!providers.containsKey(providerName)) {
      return null;
    }
    else {
      return providers[providerName];
    }
  }

  Future<Map<String, ProviderData>> _getProvidersData() async {
    if (_providersData == null) {
      _providersData = await _storage.get('providers');
    }
    return _providersData;
  }

  save(String providerName, ProviderData data) async {
    final providersData = await _getProvidersData();
    providersData[providerName] = data;
    await _storage.set('providers', providersData);
  }
}
