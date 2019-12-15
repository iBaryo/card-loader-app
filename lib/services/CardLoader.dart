import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/services/network.dart';

class CardLoader {
  Network _network;
  CardLoader(Network network): _network = network;

  Future<ProviderResponse> load(ProviderLoader loader, int sum) async {
    var payload = await loader.fetchPayload(sum);
    var rawRes = await _network.send(loader.httpMethod, loader.url, payload);
    return loader.parseResponse(rawRes);
  }
}

