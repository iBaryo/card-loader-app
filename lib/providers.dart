import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/models/ProviderRequests/ProviderAppRequest.dart';
import 'package:flutter/material.dart';

List<Provider> defineProviders() {
  return [
    Provider(
        name: 'Wolt',
        desc: 'Delieveries from different restraunts',
        icon: 'assets/wolt/icon.jpg',
        image: 'veggies.jpg',
        color: Colors.blue,
        createLoader: ({providerProfileData}) {
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
        desc: 'Pricey place with quality stuff',
        icon: 'assets/teva/icon.png',
        image: 'veggies.jpg',
        color: Colors.green,
        requiredFields: ['code'],
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Segev-Express',
        desc: 'Fast food fun',
        icon: 'assets/segev/icon.png',
        image: 'veggies.jpg',
        color: Colors.grey,
        requiredFields: ['bla'],
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Shufersal',
        desc: 'Groceries',
        icon: 'assets/shufersal/icon.png',
        image: 'veggies.jpg',
        color: Colors.red,
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Victory',
        desc: 'Groceries',
        icon: 'assets/victory/icon.png',
        image: 'veggies.jpg',
        color: Colors.red,
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Shookit',
        desc: 'Vegetables',
        icon: 'assets/shookit/icon.png',
        image: 'veggies.jpg',
        color: Colors.red,
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
    Provider(
        isActive: false,
        name: 'Super Yuda',
        desc: 'Groceries',
        icon: 'assets/yuda/icon.jpg',
        image: 'veggies.jpg',
        color: Colors.red,
        createLoader: ({providerProfileData}) {
          return ProviderLoader(createRequest: (profile, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
  ];
}
