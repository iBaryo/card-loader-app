import 'Budget.dart';

class Profile {
  CompanyCard card;
  Budget budget;

  Profile(this.card, this.budget);
  Profile.empty() {
    card = CompanyCard('','','');
    budget = Budget.empty();
  }
}

class CompanyCard {
  String firstName;
  String lastName;
  String number = '';

  CompanyCard(this.firstName, this.lastName, this.number);

  bool isActive() => firstName != '' && lastName != '' && number != '';
}