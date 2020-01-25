import 'package:card_loader/models/Profile.dart';
import 'package:card_loader/services/storage.dart';

class ProfileRepo {
  Storage storage;
  ProfileRepo({this.storage});

  Future<Profile> get() async {
    return Profile.empty();
  }
  set(Profile user) async {}
}