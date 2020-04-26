import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/Storage.dart';

class ProvidersRepo {
  Storage storage;
  Map<String, Provider> _providers;

  Future<dynamic> _providerDataFuture;
  Map<String, ProviderProfileData> _providersData;

  ProvidersRepo({this.storage, List<Provider> providers})
      : _providers = Map<String, Provider>.fromIterable(providers,
            key: (provider) => provider.name, value: (provider) => provider),
        _providerDataFuture = storage.get('providers');

  Future<ProviderLoader> createLoader(ProviderDetails provider) async {
    if (!_providers.containsKey(provider.name)) {
      throw 'Unsupported Provider: ${provider.name ?? '<null>'}';
    }

    if (provider.requiredFields.length > 0) {
//      final providersData = await _getProvidersData();
//      if (!providersData.containsKey(providerName)) {
//        // provider with no setup.
//        return null;
//      }
    }

    return _providers[provider.name].createLoader();
  }

  List<Provider> getAll() => _providers.values.toList();

  Future<List<Provider>> getActive() async {
    return _providers.values.where((provider) => provider.isActive).toList();
  }

  Future<List<Provider>> getConfigured() async {
    final configuredProviders = await _getProvidersData();
    return configuredProviders.keys
        .toList()
        .map((provName) => _providers[provName])
        .toList();
  }

  Future<List<Provider>> getWithNoSetup() async {
    return _providers.values
        .where((provider) => provider.requiredFields.length == 0)
        .toList();
  }

  Future<List<Provider>> getAvailable() async {
    final available = await Future.wait([getConfigured(), getWithNoSetup()]);
    return available
        .expand((providers) => providers)
        .toSet()
        .where((provider) => provider.isActive)
        .toList();
  }

  Future<Provider> getDefault() async {
    final available = await getAvailable();
    return available[0];
  }

  Future<T> getProviderData<T extends ProviderProfileData>(
      String providerName) async {
    final providers = await _getProvidersData();
    if (!providers.containsKey(providerName)) {
      return null;
    } else {
      return providers[providerName];
    }
  }

  Future<Map<String, ProviderProfileData>> _getProvidersData() async {
    if (_providersData == null) {
      _providersData =
          (await _providerDataFuture) ?? Map<String, ProviderProfileData>();
    }
    return _providersData;
  }

  save(String providerName, ProviderProfileData data) async {
    final providersData = await _getProvidersData();
    providersData[providerName] = data;
    await storage.set('providers', providersData);
  }
}
