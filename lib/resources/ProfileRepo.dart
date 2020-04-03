import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/services/storage.dart';

const String STORAGE_KEY = 'profile';

class ProfileRepo {
  Storage storage;

  ProfileRepo({this.storage});

  Future<Profile> get() async {
    var profileJson = await storage.get(STORAGE_KEY);
    if (profileJson == null) {
      return Profile.empty();
    }
    try {
      return Profile(
          profileJson['firstName'],
          profileJson['lastName'],
          Card(profileJson['card']['number']));
    }
    catch (e) {
      print('profile serializer error');
      return Profile.empty();
    }
  }

  set(Profile profile) async {
    storage.set(STORAGE_KEY, {
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'card': {
        'number': profile.card.number
      }
    });
  }
}