import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';

class CardLoader {
  Future<ProviderResponse> loadToProvider(
      ProviderLoader loader, Profile profile, int sum) async {
    final provReq = loader.createRequest(profile, sum);
    var rawRes = await provReq.send();
    return loader.parseResponse(rawRes);
  }
}
