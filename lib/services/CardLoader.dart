import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:http/http.dart';

class CardLoader {
  Future<ProviderResponse> loadToProvider(
      ProviderLoader loader, Profile profile, int sum) async {
    final provReq = loader.createRequest(profile, sum);
    var rawRes = await send(provReq);
    return loader.parseResponse(rawRes);
  }

  Future<String> send(ProviderRequest providerRequest) async {
    final res = await post(providerRequest.url,
        body: providerRequest.body, headers: providerRequest.headers);
    return res.body;
  }
}
