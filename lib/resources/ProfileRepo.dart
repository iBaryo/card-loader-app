import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/services/storage.dart';

const String STORAGE_KEY = 'profile';
class ProfileRepo {
  Storage storage;
  ProfileRepo({this.storage});

  Future<Profile> get() async {
    try {
      return (await storage.get<Profile>(STORAGE_KEY)) ?? Profile.empty();
    }
    catch (e) {
      return Profile.empty();
    }
  }

  set(Profile profile) async {
    storage.set(STORAGE_KEY, profile);
  }
}