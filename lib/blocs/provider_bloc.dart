import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';

class ProviderSetupBloc {
  ProvidersRepo repo;

  ProviderSetupBloc({this.repo});

  Future<ProviderDetails> get<T extends ProviderProfileData>(String providerName) =>
      repo.getProviderData(providerName);

  set<T extends ProviderProfileData>(String providerName, T data) =>
      repo.save(providerName, data);
}
