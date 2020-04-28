import 'dart:convert';

import 'package:flutter/material.dart';

import 'DirectLoad.dart';

class ProviderDetails {
  final bool isActive;
  final String name;
  final String desc;
  final String icon;
  final String image;
  final MaterialColor color;
  final List<String> requiredFields;
  final DirectLoadConfig directLoad;

  ProviderDetails(this.isActive, this.name, this.desc, this.icon, this.image,
      this.color, this.requiredFields, this.directLoad);
}

class Provider extends ProviderDetails {
  final ProviderLoader Function() createLoader;

  Provider(
      {bool isActive,
      String name,
      String desc,
      String icon,
      String image,
      MaterialColor color,
      List<String> requiredFields,
      DirectLoadConfig directLoad,
      this.createLoader})
      : super(isActive ?? true, name, desc, icon, image, color,
            requiredFields ?? [], directLoad);
}

class ProviderLoader {
  ProviderRequest Function(DirectLoad directLoad, int sum) createRequest;
  ProviderResponse Function(String rawResponse) parseResponse;

  ProviderLoader(
      {this.createRequest,
      ProviderResponse Function(String rawResponse) parseResponse})
      : this.parseResponse = parseResponse ??
            ((String rawRes) => ProviderResponse.parse(jsonDecode(rawRes)));
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
