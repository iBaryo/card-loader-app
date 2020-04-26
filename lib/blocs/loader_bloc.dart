import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/repos/BudgetRepo.dart';
import 'package:card_loader/repos/CardRepo.dart';
import 'package:card_loader/repos/ProvidersRepo.dart';
import 'package:card_loader/services/CardLoader.dart';
import 'package:card_loader/services/NotificationHandler.dart';
import 'package:card_loader/services/Notifications.dart';
import 'package:rxdart/rxdart.dart' show PublishSubject;

class CardLoaderBloc {
  final CardRepo cardRepo;
  final BudgetRepo budgetRepo;
  final ProvidersRepo providersRepo;
  final CardLoader cardLoader;
  final NotificationsService notificationsService;

  final _availableProviderNamesFetcher =
      PublishSubject<List<ProviderDetails>>();

  Stream<List<ProviderDetails>> get availableProviders$ =>
      _availableProviderNamesFetcher.stream;

  CardLoaderBloc(
      {this.cardRepo,
      this.budgetRepo,
      this.providersRepo,
      this.cardLoader,
      this.notificationsService});

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

  loadDailyBudgetToDefaultProvider() async {
    final defaultProvider = await providersRepo.getDefault();
    return await loadDailyBudgetToProvider(defaultProvider);
  }

  loadDailyBudgetToProvider(ProviderDetails provider) async {
    int amount = 0;
    final budget = await budgetRepo.get();
    if (budget.isActive()) {
      final daily = budget.daily();
      if (!budget.enoughFor(daily)) {
        return false;
      }
      amount = daily.floor();
    }
    return await loadToProvider(provider, amount);
  }

  loadToProvider(ProviderDetails provider, int sum) async {
    try {
      final card = await cardRepo.get();
      final providerLoader = await providersRepo.createLoader(provider);
      final res = await cardLoader.loadToProvider(providerLoader, sum, card);
      if (!res.ok) {
        throw res.error;
      } else {
        await updateBudget(res.pendingResponse, sum);
      }
      return true;
    } catch (e) {
      print('error loading to provider');
      print(e);
      return false;
    }
  }

  updateBudget(bool isPending, int sum) async {
    if (sum == 0) return;
    final budget = await budgetRepo.get();
    if (!budget.isActive()) return;

    if (isPending) {
      await notificationsService.show(Notification(
          'Update budget', 'When done using your credit, click here',
          payload: NotificationType.UseBudget.toString()));
    } else {
      budget.state.used += sum;
      await budgetRepo.set(budget);
    }
  }

  hasBudgetManagement() => budgetRepo.get().then((budget) => budget.isActive());
}
