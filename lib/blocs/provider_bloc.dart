import 'package:card_loader/repos/ProvidersRepo.dart';

class ProviderSetupBloc {
  ProvidersRepo repo;

  ProviderSetupBloc({this.repo});

  Future<dynamic> get(String providerName) =>
      repo.getProviderData(providerName);

  set(String providerName, dynamic data) =>
      repo.save(providerName, data);
}
