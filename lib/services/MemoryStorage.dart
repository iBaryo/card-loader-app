import 'package:card_loader/services/Storage.dart';

class MemoryStorage implements Storage {
  Map<String, dynamic> _cache = Map<String, dynamic>();

  Future<dynamic> get(String key) async {
    return Future.value(_cache.containsKey(key) ? _cache[key] : null);
  }

  set(String key, dynamic data) async {
        _cache[key] = data;
  }
}
