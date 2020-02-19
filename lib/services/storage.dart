class Storage {
  Map<String, dynamic> _cache = Map<String, dynamic>();
  Future<T> get<T>(String key) {
    // TODO
    return Future.value(_cache.containsKey(key) ? _cache[key] as T : null);
  }

  set(String key, dynamic data) {
    // TODO
    _cache[key] = data;
  }
}