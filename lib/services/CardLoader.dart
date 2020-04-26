import 'package:card_loader/models/CompanyCard.dart';
import 'package:card_loader/models/Provider.dart';

class CardLoader {
  Future<ProviderResponse> loadToProvider(
      ProviderLoader loader, int sum, CompanyCard card) async {
    print('creating the request...');
    final provReq = loader.createRequest(card, sum);
    print('sending the request...');
    final rawRes = await provReq.send();
    print('parsing response...');
    return loader.parseResponse(rawRes);
  }
}
