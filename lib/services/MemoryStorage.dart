import 'package:card_loader/services/Storage.dart';

class MemoryStorage implements Storage {
  Map<String, dynamic> _cache = Map<String, dynamic>();

  @override
  Future<dynamic> get(String key) async {
    return Future.value(_cache.containsKey(key) ? _cache[key] : null);
  }

  @override
  set(String key, dynamic data) async {
    _cache[key] = data;
  }

  @override
  clear(String key) => _cache.remove(key);
}
