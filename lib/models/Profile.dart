class Profile {
  String firstName;
  String lastName;
  Card card;
  Budget budget;

  Profile(this.firstName, this.lastName, this.card, this.budget);
  Profile.empty() {
    firstName = '';
    lastName = '';
    card = Card('');
    budget = Budget.empty();
  }
}

class Card {
  String number = '';

  Card(this.number);
}

class Budget {
  static const WORKDAYS_PER_WEEK = DateTime.daysPerWeek - 2;

  BudgetSettings settings;
  BudgetState state;

  Budget(this.settings, this.state) {
    validateState();
  }

  Budget.empty() {
    settings = BudgetSettings.empty();
    state = BudgetState.empty();
  }

  bool any() {
    return settings.limit > state.used;
  }

  double daily() {
    int workDays;
    switch (settings.frequency) {
      case BudgetFrequency.DAILY:
        workDays = 1;
        break;
      case BudgetFrequency.WEEKLY:
        workDays = WORKDAYS_PER_WEEK;
        break;
      case BudgetFrequency.MONTHLY:
        workDays = WORKDAYS_PER_WEEK * 4;
        break;
    }

    return settings.limit / workDays;
  }

  validateState() {
    if (shouldResetState()) {
      state = BudgetState.empty();
    }
  }

  bool shouldResetState() {
    if (state.until.microsecondsSinceEpoch == 0) {
      return false;
    }

    final now = DateTime.now();
    switch (settings.frequency) {
      case BudgetFrequency.DAILY:
        return now.isAfter(state.until);
      case BudgetFrequency.WEEKLY:
        final nextWeekReset = state.until
            .add(Duration(days: DateTime.daysPerWeek - state.until.weekday));
        return now.isAfter(nextWeekReset);
      case BudgetFrequency.MONTHLY:
        return state.until.month != now.month;
      default:
        return false;
    }
  }
}

class BudgetState {
  double used;
  DateTime until;

  BudgetState(this.used, this.until);

  BudgetState.empty() {
    used = 0;
    until = DateTime.fromMicrosecondsSinceEpoch(0);
  }
}

class BudgetSettings {
  double limit = 0;
  BudgetFrequency frequency = BudgetFrequency.DAILY;

  BudgetSettings.empty();

  BudgetSettings(this.limit, this.frequency);
}

enum BudgetFrequency { DAILY, WEEKLY, MONTHLY }
