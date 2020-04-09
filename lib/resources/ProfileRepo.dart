import 'package:card_loader/models/Budget.dart';
import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/services/Storage.dart';

const String STORAGE_KEY = 'profile';

class ProfileRepo {
  Storage storage;

  ProfileRepo({this.storage});

  Future<Profile> get() {
      return _loadProfile();
  }

  Future<Profile> _loadProfile() async {
    var profileJson = await storage.get(STORAGE_KEY);
    if (profileJson == null) {
      return Profile.empty();
    }
    try {
      var card = profileJson['card'],
          budget = profileJson['budget'],
          bSettings = budget['settings'],
          bState = budget['state'];

      return Profile(
          profileJson['firstName'],
          profileJson['lastName'],
          Card(card['number']),
          Budget(
              BudgetSettings(bSettings['limit'],
                  BudgetFrequency.values[bSettings['frequency']]),
              BudgetState(bState['used'],
                  DateTime.fromMicrosecondsSinceEpoch(bState['until']))));
    } catch (e) {
      print('profile serializer error');
      return Profile.empty();
    }
  }

  set(Profile profile) async {
    var budget = profile.budget;

    storage.set(STORAGE_KEY, {
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'card': {'number': profile.card.number},
      'budget': {
        'settings': {
          'limit': budget.settings.limit,
          'frequency': budget.settings.frequency.index
        },
        'state': {
          'used': budget.state.used,
          'until': budget.state.until.microsecondsSinceEpoch
        }
      }
    });
  }
}
