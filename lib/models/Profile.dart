import 'Budget.dart';

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