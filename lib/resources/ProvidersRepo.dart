import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/storage.dart';

class ProvidersRepo {
  Storage storage;
  Map<String, Provider> _providers;
  Map<String, ProviderProfileData> _providersData;

  ProvidersRepo({this.storage, List<Provider> providers})
      : _providers = Map<String, Provider>.fromIterable(providers,
            key: (provider) => provider.name, value: (provider) => provider);

  Future<ProviderLoader> createLoader(String providerName) async {
    if (!_providers.containsKey(providerName)) {
      // unsupported provider.
      return null;
    }

    final providersData = await _getProvidersData();
    if (!providersData.containsKey(providerName)) {
      // provider with no setup.
      return null;
    }

    return _providers[providerName].createLoader(providersData[providerName]);

  }


  Iterable<Provider> getAll() => _providers.values;

  Future<Iterable<Provider>> getAvailable() async {
    final availableProviders = await _getProvidersData();
    return availableProviders.keys.map((provName) => _providers[provName]);
  }

  Future<T> getProviderData<T extends ProviderProfileData>(String providerName) async {
    final providers = await _getProvidersData();
    if (!providers.containsKey(providerName)) {
      return null;
    }
    else {
      return providers[providerName];
    }
  }

  Future<Map<String, ProviderProfileData>> _getProvidersData() async {
    if (_providersData == null) {
      print('loading configured providers');
      _providersData = (await storage.get('providers')) ?? Map<String, ProviderProfileData>();
    }
    return _providersData;
  }

  save(String providerName, ProviderProfileData data) async {
    final providersData = await _getProvidersData();
    providersData[providerName] = data;
    await storage.set('providers', providersData);
  }
}
