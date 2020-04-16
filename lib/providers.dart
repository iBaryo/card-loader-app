import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/models/ProviderRequests/ProviderAppRequest.dart';
import 'package:flutter/material.dart';

List<Provider> defineProviders() {
  return [
    Provider(
        name: 'Wolt',
        desc: 'Food delieveries',
        icon: Icons.traffic,
        image: 'veggies.jpg',
        color: Colors.blue,
        createLoader: (providerProfileData) {
          return ProviderLoader(
              createRequest: (profile, sum) => ProviderAppRequest(
                  'https://wolt.com/en/isr/tel-aviv/restaurant/woltilgiftcards'),
              parseResponse: (rawResponse) {
                return null;
              });
        }),
    Provider(
//        isEnabled: false,
        name: 'Teva-Castel',
        desc: 'pricey place with quality stuff',
        icon: Icons.nature,
        image: 'veggies.jpg',
        color: Colors.green,
        requiredFields: ['code'],
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Segev-Express',
        desc: 'meaty meat',
        icon: Icons.fastfood,
        image: 'segev.jpg',
        color: Colors.grey,
        requiredFields: ['bla'],
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Shufersal',
        desc: 'groceries',
        icon: Icons.shopping_cart,
        image: 'segev.jpg',
        color: Colors.red,
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Victory',
        desc: 'groceries',
        icon: Icons.shopping_cart,
        image: 'segev.jpg',
        color: Colors.red,
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Shookit',
        desc: 'vegetables',
        icon: Icons.streetview,
        image: 'segev.jpg',
        color: Colors.red,
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Super Yuda',
        desc: 'groceries',
        icon: Icons.shopping_cart,
        image: 'segev.jpg',
        color: Colors.red,
        createLoader: (providerProfileData) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
  ];
}
