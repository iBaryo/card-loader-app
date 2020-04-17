import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/repos/ProfileRepo.dart';
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
    return true;
  }

  fetchProviders() async {
    List<ProviderDetails> providers = await providersRepo.getAvailable();

    _availableProviderNamesFetcher.sink.add(providers);
  }

  dispose() {
    _availableProviderNamesFetcher.close();
  }

  loadToProvider(String providerName, int sum) async {
    final profile = await profileRepo.get();
    final providerLoader = await providersRepo.createLoader(providerName);

    if (providerLoader == null) {
      // todo: throw
    } else {
      await cardLoader.loadToProvider(providerLoader, profile, sum);
      await updateBudget(profile, sum);
    }
  }

  updateBudget(Profile profile, int sum) async {
    profile.budget.state.used += sum;
    await profileRepo.set(profile);
  }
}
