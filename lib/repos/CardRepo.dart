import 'package:card_loader/models/CompanyCard.dart';
import 'package:card_loader/repos/BaseRepo.dart';
import 'package:card_loader/services/Storage.dart';

class CardRepo extends BaseRepo<CompanyCard> {
  CardRepo({Storage storage}) : super(storage);

  @override
  String getStorageKey() => 'card';

  @override
  CompanyCard empty() => CompanyCard.empty();

  @override
  CompanyCard parse(json) =>
      CompanyCard(json['firstName'], json['lastName'], json['number']);

  @override
  stringify(CompanyCard card) => {
        'firstName': card.firstName,
        'lastName': card.lastName,
        'number': card.number
      };
}
