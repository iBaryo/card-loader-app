import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/resources/ProfileRepo.dart';
import 'package:rxdart/rxdart.dart';

class LoaderBloc {
  final ProfileRepo _userRepo;
  final ProvidersRepo _providersRepo;
  final CardLoader _cardLoader;

  final _availableProviderNamesFetcher =
      PublishSubject<Iterable<ProviderDetails>>();

  Stream<Iterable<ProviderDetails>> get availableProviders =>
      _availableProviderNamesFetcher.stream;

  LoaderBloc(ProfileRepo userRepo, ProvidersRepo providers, CardLoader cardLoader)
      : _userRepo = userRepo,
        _providersRepo = providers,
        _cardLoader = cardLoader;

  fetchProviders() async {
    Iterable<ProviderDetails> providerNames =
        await _providersRepo.getAvailable();
    _availableProviderNamesFetcher.sink.add(providerNames);
  }

  dispose() {
    _availableProviderNamesFetcher.close();
  }

  loadToProvider(String providerName, int sum) async {
    final profile = await _userRepo.get();
    final providerLoader =
        await _providersRepo.createLoader(profile, providerName);
    if (providerLoader == null) {
      // todo: throw
    } else {
      await _cardLoader.load(providerLoader, sum);
    }
  }
}
