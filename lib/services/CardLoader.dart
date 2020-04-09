import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';

class CardLoader {
  Future<ProviderResponse> loadToProvider(
      ProviderLoader loader, Profile profile, int sum) async {
    print('creating the request...');
    final provReq = loader.createRequest(profile, sum);
    print('sending the request...');
    var rawRes = await provReq.send();
    print('parsing response...');
    return loader.parseResponse(rawRes);
  }
}
