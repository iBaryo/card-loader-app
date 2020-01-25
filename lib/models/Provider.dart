import 'dart:io';

import 'package:card_loader/models/Profile.dart';

abstract class ProviderProfileData {}

abstract class ProviderDetails {
  String get name;
  String get desc;
  String get icon;
}

abstract class Provider<T extends ProviderProfileData> extends ProviderDetails {
  ProviderLoader createLoader(T providerProfileData);
}

class ProviderRequest {
  String url;
  Map<String, String> headers;
  String body;

  ProviderRequest(url, {String body, Map<String, String> headers})
      :  url = url,
        body = body,
        headers = headers;

}

abstract class ProviderLoader {
  ProviderRequest createRequest(Profile profile, int sum);

  ProviderResponse parseResponse(String rawResponse);
//  String url;
//  String httpMethod;
//  Future<String> Function(int sum) fetchPayload;
//  ProviderResponse Function(String rawRes) parseResponse;
//
//  ProviderLoader(
//      {String url,
//      String httpMethod,
//      Future<String> Function(int sum) fetchPayload,
//      ProviderResponse Function(String rawRes) parseResponse})
//      : url = url,
//        httpMethod = httpMethod,
//        fetchPayload = fetchPayload,
//        parseResponse = parseResponse;
}

class ProviderResponse {}
