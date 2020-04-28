import 'package:card_loader/models/DirectLoad.dart';
import 'package:card_loader/models/Provider.dart';
import 'package:card_loader/models/ProviderRequests/ProviderAppRequest.dart';
import 'package:card_loader/models/ProviderRequests/ProviderHttpRequest.dart';
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
            createRequest: (_, __) => ProviderAppRequest(
                'https://wolt.com/en/isr/tel-aviv/restaurant/woltilgiftcards'),
          );
        }),
    Provider(
        isActive: true,
        name: 'Teva-Castel',
        desc: 'Pricey place with quality stuff',
        icon: 'assets/teva/icon.png',
        image: 'veggies.jpg',
        color: Colors.green,
        directLoad: DirectLoadConfig(['code']),
        createLoader: () {
          return ProviderLoader(
            createRequest: (directLoad, sum) {
              if (!directLoad.isActive()) {
                return ProviderAppRequest(
                    'http://lp.infopage.mobi/index.php?page=landing&id=88919&token=4e9239fbe46144506e04081009a09a47');
              } else {
                return ProviderHttpRequest('', body: '', headers: {});
              }
            },
//          parseResponse: (rawResponse) {
//            return null;
//          }
          );
        }),
    Provider(
        isActive: false,
        name: 'Segev-Express',
        desc: 'Fast food fun',
        icon: 'assets/segev/icon.png',
        image: 'veggies.jpg',
        color: Colors.grey,
        requiredFields: ['bla'],
        createLoader: () {
          return ProviderLoader(createRequest: (directLoad, sum) {
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
        createLoader: () {
          return ProviderLoader(createRequest: (directLoad, sum) {
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
        createLoader: () {
          return ProviderLoader(createRequest: (directLoad, sum) {
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
        createLoader: () {
          return ProviderLoader(createRequest: (directLoad, sum) {
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
        createLoader: () {
          return ProviderLoader(createRequest: (directLoad, sum) {
            return null;
          }, parseResponse: (rawResponse) {
            return null;
          });
        }),
  ];
}
