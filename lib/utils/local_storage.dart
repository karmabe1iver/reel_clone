import 'package:get_storage/get_storage.dart';
abstract class LocalStore {


  static dynamic setData(String key, dynamic value) =>
      GetStorage().write(key, value);

  static dynamic getData(String key) => GetStorage().read(key);

  static void remove(String key) => GetStorage().remove(key);

  static void clearData() async => GetStorage().erase();
}



