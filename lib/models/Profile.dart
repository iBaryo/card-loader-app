class Profile {
  static Profile empty() => Profile('', '', Card(''));

  Profile(this.firstName, this.lastName, this.card);

  Card card;
  String firstName;
  String lastName;
}

class Card {
  String number;
  Card(this.number);
}