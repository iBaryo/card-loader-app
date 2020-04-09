import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/resources/ProvidersRepo.dart';
import 'package:card_loader/resources/ProfileRepo.dart';
import 'package:rxdart/rxdart.dart';

class CardLoaderBloc {
  final ProfileRepo profileRepo;
  final ProvidersRepo providersRepo;
  final CardLoader cardLoader;

  final _availableProviderNamesFetcher =
      PublishSubject<List<ProviderDetails>>();

  Stream<List<ProviderDetails>> get availableProviders$ =>
      _availableProviderNamesFetcher.stream;

  CardLoaderBloc({this.profileRepo, this.providersRepo, this.cardLoader});

  Future<bool> hasRequiredInfo() async {
    final profile = await profileRepo.get();
    final res = [
      profile.card,
      profile.firstName,
      profile.lastName
    ].every((d) => (d?.toString() ?? '') != ''); // null or empty

    return res;
  }

  fetchProviders() async {
    List<ProviderDetails> providers =
        await providersRepo.getAvailable();

    _availableProviderNamesFetcher.sink.add(providers);
  }

  dispose() {
    _availableProviderNamesFetcher.close();
  }

  loadToProvider(String providerName, int sum) async {
    final providerLoader =
        await providersRepo.createLoader(providerName);
    if (providerLoader == null) {
      // todo: throw
    } else {
      final profile = await profileRepo.get();
      try {
        await cardLoader.loadToProvider(providerLoader, profile, sum);
      } catch (e) {
        print('error loading to provider $providerName');
        print(e);
      }
    }
  }
}
