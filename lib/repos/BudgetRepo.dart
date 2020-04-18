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
    final bSettings = json['settings'], bState = json['state'];

    return Budget(
        settings: BudgetSettings(
            bSettings['limit'], BudgetFrequency.values[bSettings['frequency']]),
        state: BudgetState(bState['used'],
            DateTime.fromMicrosecondsSinceEpoch(bState['until'])));
  }

  @override
  stringify(Budget budget) {
    return {
      'settings': {
        'limit': budget.settings.limit,
        'frequency': budget.settings.frequency.index
      },
      'state': {
        'used': budget.state.used,
        'until': budget.state.until.microsecondsSinceEpoch
      }
    };
  }
}
