import 'dart:convert';

import 'package:card_loader/models/CompanyCard.dart';
import 'package:flutter/material.dart';

abstract class ProviderProfileData {}

class ProviderDetails {
  final bool isActive;
  final String name;
  final String desc;
  final String icon;
  final String image;
  final MaterialColor color;
  final List<String> requiredFields;

  ProviderDetails(this.isActive, this.name, this.desc, this.icon, this.image,
      this.color, this.requiredFields);
}

class Provider<T extends ProviderProfileData> extends ProviderDetails {
  final ProviderLoader Function({T providerProfileData}) createLoader;

  Provider(
      {bool isActive,
      String name,
      String desc,
      String icon,
      String image,
      MaterialColor color,
      List<String> requiredFields,
      this.createLoader})
      : super(isActive ?? true, name, desc, icon, image, color,
            requiredFields ?? []);
}

class ProviderLoader {
  ProviderRequest Function(CompanyCard card, int sum) createRequest;
  ProviderResponse Function(String rawResponse) parseResponse =
      (rawRes) => ProviderResponse.parse(jsonDecode(rawRes));

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

abstract class ProviderRequest {
  final String url;

  ProviderRequest(this.url);

  Future<String> send();
}

class ProviderResponse {
  final bool ok;
  bool pendingResponse = false;
  String error = '';

  ProviderResponse(this.ok, {this.pendingResponse, this.error});

  ProviderResponse.parse(dynamic raw)
      : ok = raw['ok'],
        pendingResponse = raw['pendingResponse'],
        error = raw['error'];

  toMap() => {
        'ok': this.ok,
        'pendingResponse': this.pendingResponse,
        'error': this.error
      };
}
