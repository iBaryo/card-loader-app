import 'package:card_loader/models/IActive.dart';

class Budget implements IActive {
  static const WORKDAYS_PER_WEEK = DateTime.daysPerWeek - 2;

  BudgetSettings settings;
  BudgetState state;

  Budget({this.settings, this.state}) {
    validateState();
  }

  Budget.empty() {
    settings = BudgetSettings.empty();
    resetState();
  }

  @override
  bool isActive() => settings.isActive();

  bool enoughFor(double amount) =>
      settings.isPassingAnyLimit(getUsed() + amount);

  bool any() => enoughFor(0);

  double getUsed() => state.sum();

  double getDailyBudget() {
    double limit = 0;
    int workDays = 1;

    if (settings.hasLimit(BudgetFrequency.DAILY)) {
      limit = settings.limits[BudgetFrequency.DAILY];
      workDays = 1;
    } else if (settings.hasLimit(BudgetFrequency.WEEKLY)) {
      limit = settings.limits[BudgetFrequency.WEEKLY];
      workDays = WORKDAYS_PER_WEEK;
    } else if (settings.hasLimit(BudgetFrequency.MONTHLY)) {
      limit = settings.limits[BudgetFrequency.MONTHLY];
      workDays = WORKDAYS_PER_WEEK * 4;
    }

    return limit / workDays;
  }

  validateState() {
    if (state.transactions.length > 0 && shouldResetState(state.mostRecent().when)) {
      resetState();
    }
  }

  resetState() {
    state = BudgetState.empty();
  }

  bool shouldResetState(DateTime stateTime) {
    if (stateTime.microsecondsSinceEpoch == 0) {
      return false;
    }

    final now = DateTime.now();
    // ORDER MATTERS! -- need to keep state according to longest frequency.
    return (settings.hasLimit(BudgetFrequency.MONTHLY) &&
        stateTime.month != now.month) ||
        (settings.hasLimit(BudgetFrequency.WEEKLY) &&
            now.isAfter(getNextWeek(stateTime))) ||
        (settings.hasLimit(BudgetFrequency.DAILY) && now.isAfter(stateTime));
  }

  DateTime getNextWeek(DateTime dateTime) =>
      dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

class BudgetState {
  final List<CreditTransaction> transactions;

  BudgetState(this.transactions);

  BudgetState.empty() : transactions = [];

  add(CreditTransaction transaction) => transactions.add(transaction);

  BudgetState getSince(DateTime since) =>
      BudgetState(transactions.where((tran) => since.isBefore(tran.when)));

  double sum() =>
      transactions.map((tran) => tran.used).reduce((res, sum) => res + sum);

  CreditTransaction mostRecent() =>
      transactions.reduce((recent, cur) =>
      recent.when.isAfter(cur.when)
          ? recent
          : cur) ?? CreditTransaction;
}

class CreditTransaction {
  final DateTime when;
  final double used;

  CreditTransaction(this.when, this.used);
}

class BudgetSettings with IActive {
  Map<BudgetFrequency, double> limits = {
    BudgetFrequency.DAILY: null,
    BudgetFrequency.WEEKLY: null,
    BudgetFrequency.MONTHLY: null,
  };

  BudgetSettings.empty();

  BudgetSettings(this.limits);

  bool hasLimit(BudgetFrequency freq) => limits[freq] != null;
  bool reset(BudgetFrequency freq) => limits[freq] = null;

  bool isPassingAnyLimit(double sum) =>
      limits.values.any((limit) => (limit ?? -1) < sum);

  bool isActive() => limits.values.any((limit) => limit != null) && isValid();

  bool isValid() =>
      (limits[BudgetFrequency.DAILY] ?? double.minPositive) <=
          (limits[BudgetFrequency.WEEKLY] ?? double.maxFinite) &&
          (limits[BudgetFrequency.WEEKLY] ?? double.minPositive) <=
              (limits[BudgetFrequency.MONTHLY] ?? double.maxFinite) &&
          (limits[BudgetFrequency.DAILY] ?? double.minPositive) <=
              (limits[BudgetFrequency.MONTHLY] ?? double.maxFinite);
}

enum BudgetFrequency { DAILY, WEEKLY, MONTHLY }
