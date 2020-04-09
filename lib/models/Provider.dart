import 'dart:io';

import 'package:card_loader/models/Profile.dart';
import 'package:flutter/material.dart';

abstract class ProviderProfileData {}

class ProviderDetails {
  String name;
  String desc;
  IconData icon;
  String image;
  MaterialColor color;
  List<String> requiredFields;

  ProviderDetails(this.name, this.desc, this.icon, this.image, this.color,
      this.requiredFields);
}

class Provider<T extends ProviderProfileData> extends ProviderDetails {
  ProviderLoader Function(T providerProfileData) createLoader;

  Provider(
      {String name,
      String desc,
      IconData icon,
      String image,
      MaterialColor color,
      List<String> requiredFields,
      this.createLoader})
      : super(name, desc, icon, image, color, requiredFields);
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

abstract class ProviderRequest {
  String url;
  ProviderRequest(this.url);
  Future<String> send();
}

class ProviderResponse {}
