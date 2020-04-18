import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/BudgetRepo.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:rxdart/rxdart.dart';

class CardLoaderBloc {
  final CardRepo cardRepo;
  final BudgetRepo budgetRepo;
  final ProvidersRepo providersRepo;
  final CardLoader cardLoader;

  final _availableProviderNamesFetcher =
      PublishSubject<List<ProviderDetails>>();

  Stream<List<ProviderDetails>> get availableProviders$ =>
      _availableProviderNamesFetcher.stream;

  CardLoaderBloc(
      {this.cardRepo, this.budgetRepo, this.providersRepo, this.cardLoader});

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
    final card = await cardRepo.get();
    final providerLoader = await providersRepo.createLoader(providerName);

    if (providerLoader == null) {
      // todo: throw
    } else {
      await cardLoader.loadToProvider(providerLoader, sum, card);
      await updateBudget(sum);
    }
  }

  updateBudget(int sum) async {
    final budget = await budgetRepo.get();
    budget.state.used += sum;
    await budgetRepo.set(budget);
  }
}
