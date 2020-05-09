import 'package:card_loader/models/Budget.dart';
import 'package:card_loader/repos/BaseRepo.dart';
import 'package:card_loader/services/Storage.dart';

class BudgetRepo extends BaseRepo<Budget> {
  BudgetRepo({Storage storage}) : super(storage);

  @override
  String getStorageKey() => 'budget';

  @override
  Budget empty() => Budget.empty();

  @override
  Budget parse(json) {
    final bSettings = json['settings'],
        bState = json['state'];

    return Budget(
        settings: BudgetSettings(Map.fromEntries(BudgetFrequency.values.map(
                (freq) =>
                MapEntry(freq, bSettings['limits'][freq.toString()])))),
        state: BudgetState(
            List<CreditTransaction>.from(bState['transactions'].map((t) =>
                CreditTransaction(
                    DateTime.fromMicrosecondsSinceEpoch(t['when']),
                    t['used'])))));
  }

  @override
  stringify(Budget budget) {
    return {
      'settings': {
        'limits': Map.fromEntries(budget.settings.limits.entries
            .where((entry) => entry.value != null)
            .map((entry) => MapEntry(entry.key.toString(), entry.value)))
      },
      'state': {
        'transactions': budget.state.transactions
            .map((t) =>
        ({'used': t.used, 'when': t.when.microsecondsSinceEpoch}))
            .toList()
      }
    };
  }
}