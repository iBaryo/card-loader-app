import 'package:card_loader/models/Provider.dart';
import 'package:flutter/material.dart';

List<Provider> defineProviders() {
  return [
    Provider(
      name: 'Teva-Castel',
      desc: 'pricey place with quality stuff',
      icon: Icons.nature,
      createLoader: (providerProfileData) {
        return ProviderLoader(
          createRequest: (profile, sum) {
            return null;
          },
          parseResponse: (rawResponse) {
            return null;
          }
        );
      }
    ),
    Provider(
        name: 'Segev-Express',
        desc: 'meaty meat',
        icon: Icons.fastfood,
        createLoader: (providerProfileData) {
          return ProviderLoader(
              createRequest: (profile, sum) {
                return null;
              },
              parseResponse: (rawResponse) {
                return null;
              }
          );
        }
    )
  ];
}