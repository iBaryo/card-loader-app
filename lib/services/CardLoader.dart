import 'package:card_loader/models/CompanyCard.dart';
import 'package:card_loader/models/DirectLoad.dart';
import 'package:card_loader/models/Provider.dart';

class CardLoader {
  Future<ProviderResponse> loadToProvider(
      ProviderLoader loader, DirectLoad directLoad, int sum) async {
    print('creating the request...');
    final provReq = loader.createRequest(directLoad, sum);
    print('sending the request...');
    final rawRes = await provReq.send();
    print('parsing response...');
    return loader.parseResponse(rawRes);
  }
}
