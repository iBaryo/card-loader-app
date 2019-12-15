import 'package:card_loader/models/Profile.dart';

abstract class ProviderData {}

abstract class ProviderDetails {
  String get name;
  String get icon;
}

abstract class Provider<T extends ProviderData> extends ProviderDetails {
  ProviderLoader createLoader(Profile profile, T data);
}

class ProviderLoader {
  String url;
  String httpMethod;
  Future<Map<String, dynamic>> Function(int sum) fetchPayload;
  ProviderResponse Function(Map<String, dynamic> rawRes) parseResponse;

  ProviderLoader(
      {String url,
      String httpMethod,
      Future<Map<String, dynamic>> Function(int sum) fetchPayload,
      ProviderResponse Function(Map<String, dynamic> rawRes) parseResponse})
      : url = url,
        httpMethod = httpMethod,
        fetchPayload = fetchPayload,
        parseResponse = parseResponse;
}

class ProviderResponse {}
