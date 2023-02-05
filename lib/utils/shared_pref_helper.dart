import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences prefs;
  static SharedPrefHelper instance;

  // key names for prefrence data storage
  static const String IS_OLD_DATA_EMPTY = "is_old_data_empty";

  // static const String CARD_LIST = "card_list";

  SharedPrefHelper._(this.prefs);

  static Future<void> createInstance() async {
    instance = SharedPrefHelper._(await SharedPreferences.getInstance());
  }

  void putBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = true}) {
    if (prefs.containsKey(key)) {
      return prefs.getBool(key);
    }
    return defaultValue;
  }

  void clear() {
    prefs.clear();
  }

  void remove(String key) {
    prefs.remove(key);
  }
}
