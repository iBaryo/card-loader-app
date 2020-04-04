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
  BudgetSettings settings;
  BudgetState state;

  Budget(this.settings, this.state);

  Budget.empty() {
    this.settings = BudgetSettings.empty();
    this.state = BudgetState.empty();
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
