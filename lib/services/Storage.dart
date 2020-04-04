import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<dynamic> get(String key) async {
    var prefs = await SharedPreferences.getInstance();
    var res = prefs.getString(key);

    if (res == null) {
      return null;
    }

    try {
      return jsonDecode(res);
    } catch (e) {
      print('json decode threw');
      print(e);
      return null;
    }
  }

  set(String key, dynamic data) async {
    var prefs = await SharedPreferences.getInstance();
    if (data == null) {
      prefs.remove(key);
    } else {
      var stringify = jsonEncode(data);
      prefs.setString(key, stringify);
    }
  }
}