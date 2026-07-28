import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  //! Here The Initialize of cache .
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  String? getDataString(String key) {
    return _sharedPreferences.getString(key);
  }

  //! this method to put data in local database using key

  Future<dynamic> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    }

    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    } else {
      return await _sharedPreferences.setDouble(key, value);
    }
  }

  //! this method to get data already saved in local database

  dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  //! remove data using specific key

  Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  //! this method to check if local database contains {key}
  Future<bool> containsKey({required String key}) async {
    return _sharedPreferences.containsKey(key);
  }

  Future<bool> clearData({required String key}) async {
    return _sharedPreferences.clear();
  }

  //! this fun to put data in local data base using key
  Future<dynamic> put({required String key, required dynamic value}) async {
    if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else {
      return await _sharedPreferences.setInt(key, value);
    }
  }
}
