import 'package:card_loader/services/Storage.dart';

abstract class BaseRepo<T> {
  Storage storage;

  BaseRepo(this.storage);

  String getStorageKey();

  Future<T> get() async {
    final json = await storage.get(getStorageKey());
    if (json == null) {
      return empty();
    }

    try {
      return parse(json);
    } catch (e) {
      print('error while parsing ${getStorageKey()} from storage');
      print(e);
      return empty();
    }
  }

  Future set(T model) => storage.set(getStorageKey(), stringify(model));

  Future clear() => storage.clear(getStorageKey());

  T empty();

  dynamic stringify(T model);

  T parse(dynamic json);
}
