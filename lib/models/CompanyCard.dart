import 'package:card_loader/models/IActive.dart';

class CompanyCard implements IActive {
  String firstName;
  String lastName;
  String number = '';

  CompanyCard(this.firstName, this.lastName, this.number);
  CompanyCard.empty() {
    firstName = '';
    lastName = '';
    number = '';
  }

  bool isActive() => firstName != '' && lastName != '' && number != '';
}