import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String userData = 'user_data';
  static const String isSignIn = 'is_sign_in';
  static const String userLanguage = 'user_language';
  static const String authToken = 'auth_token';
  static const String accessToken = 'access_token';
  static const String fcmToken = 'fcm_token';
  static const String currentLat = 'current_latitude';
  static const String currentLong = 'current_long';
  static const String userGetProfileData = 'user_get_profile_data';
  static const String userGetStatusList = 'user_get_status_list';
  static const String userGetUpdateDispatchStatusList =
      'job_status_update_dispatch';
  static const String getInvoiceList = 'get_invoice_list';
  static const String jobStatusTagsNotes = 'job_status_tags_notes';
  static const String jobTypesHistoryFilter = 'job_types_filter';
  static const String currentRoute = 'current_route';
  static const String myJob = 'my_job';

  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryPrefs = <String, dynamic>{};

  static Future<SharedPreferences> load() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  static void setString(String key, String value) {
    _prefs!.setString(key, value);
    _memoryPrefs[key] = value;
  }

  static void setInt(String key, int value) {
    _prefs!.setInt(key, value);
    _memoryPrefs[key] = value;
  }

  static void setDouble(String key, double value) {
    _prefs!.setDouble(key, value);
    _memoryPrefs[key] = value;
  }

  static void setBool(String key, bool value) {
    _prefs!.setBool(key, value);
    _memoryPrefs[key] = value;
  }

  static String? getString(String key, {String? def}) {
    String? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs?.getString(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static int getInt(String key, {int? def}) {
    int? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getInt(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val!;
  }

  static double getDouble(String key, {double? def}) {
    double? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getDouble(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val!;
  }

  static bool getBool(String key, {bool def = false}) {
    bool? val;
    if (_memoryPrefs.containsKey(key)) {
      val = _memoryPrefs[key];
    }
    val ??= _prefs!.getBool(key);
    val ??= def;
    _memoryPrefs[key] = val;
    return val;
  }

  static Future<void> clear() async {
    _memoryPrefs.clear();
    await _prefs!.clear();
  }

  static void remove(String key) {
    _memoryPrefs.remove(key);
    _prefs!.remove(key);
  }
}
