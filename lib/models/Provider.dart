import 'dart:io';

import 'package:card_loader/models/Profile.dart';
import 'package:flutter/material.dart';

abstract class ProviderProfileData {}

class ProviderDetails {
  String name;
  String desc;
  IconData icon;
}

class Provider<T extends ProviderProfileData> extends ProviderDetails {
  String name;
  String desc;
  IconData icon;
  ProviderLoader Function(T providerProfileData) createLoader;

  Provider({this.name, this. desc, this.icon, this.createLoader});
}

class ProviderLoader {
  ProviderRequest Function(Profile profile, int sum) createRequest;
  ProviderResponse Function(String rawResponse) parseResponse;

  ProviderLoader({this.createRequest, this.parseResponse});
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

class ProviderRequest {
  String url;
  Map<String, String> headers;
  String body;

  ProviderRequest(url, {String body, Map<String, String> headers})
      :  url = url,
        body = body,
        headers = headers;

}

class ProviderResponse {}
