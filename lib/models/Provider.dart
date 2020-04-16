import 'dart:io';

import 'package:card_loader/models/Profile.dart';
import 'package:flutter/material.dart';

abstract class ProviderProfileData {}

class ProviderDetails {
  final bool isActive;
  final String name;
  final String desc;
  final IconData icon;
  final String image;
  final MaterialColor color;
  final List<String> requiredFields;

  ProviderDetails(this.isActive, this.name, this.desc, this.icon, this.image,
      this.color, this.requiredFields);
}

class Provider<T extends ProviderProfileData> extends ProviderDetails {
  final ProviderLoader Function(T providerProfileData) createLoader;

  Provider(
      {bool isActive,
      String name,
      String desc,
      IconData icon,
      String image,
      MaterialColor color,
      List<String> requiredFields,
      this.createLoader})
      : super(isActive ?? true, name, desc, icon, image, color,
            requiredFields ?? []);
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
  final String url;

  ProviderRequest(this.url);

  Future<String> send();
}

class ProviderResponse {}
