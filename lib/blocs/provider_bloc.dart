import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';

class ProviderBloc {
  ProvidersRepo _providersRepo;

  ProviderBloc(ProvidersRepo providersRepo) : _providersRepo = providersRepo;

  // todo: stream?
  Future<ProviderDetails> get<T extends ProviderData>(String providerName) =>
      _providersRepo.getProviderData(providerName);

  set<T extends ProviderData>(String providerName, T data) =>
      _providersRepo.save(providerName, data);
}
