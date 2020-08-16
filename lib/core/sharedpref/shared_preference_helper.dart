import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _isDarkTheme = "is_dark_mode";
  static final String _authToken = "token";
  static final String _language = "language";
  static final String _intro = "intro";
  static final String _isFirstLogin = "is_first_login";
  static final String _fcmId = "fcm_id";
  static final String _radioListenCount = "radio_listening_count";
  static final String _sleepingTime = "sleeping_time";
  static final String _showAudioAdXMinute = "show_audio_ad_x_minute";

  /// Shared Pref Instance
  final Future<SharedPreferences> _sharedPreference;

  /// Constructor
  SharedPreferenceHelper(this._sharedPreference);

  /// Get Auth Token
  Future<String> getAuthToken() async {
    return _sharedPreference.then((preference) {
      return preference.getString(_authToken);
    });
  }

  /// Save Auth Token
  Future<void> saveAuthToken(String authToken) async {
    return _sharedPreference.then((preference) {
      preference.setString(_authToken, authToken);
    });
  }

  /// Remove Auth Token
  Future<void> removeAuthToken() async {
    return _sharedPreference.then((preference) {
      preference.remove(_authToken);
    });
  }

  /// Is Logged In
  Future<bool> isLoggedIn() async {
    return _sharedPreference.then((preference) {
      return preference.getString(_authToken)?.isNotEmpty ?? false;
    });
  }

  /// Is Dark Mode
  Future<bool> isDarkTheme() {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(_isDarkTheme) ?? false;
    });
  }

  /// Set Dark Mode
  Future<void> setDarkMode(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(_isDarkTheme, value);
    });
  }

  /// Get Language
  Future<String> getLanguage() {
    return _sharedPreference.then((prefs) {
      return prefs.getString(_language);
    });
  }

  /// Set Language
  Future<void> setLanguage(String language) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(_language, language);
    });
  }

  /// Get Audio Ad Minute
  Future<int> getAudioAdMinute() {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(_showAudioAdXMinute);
    });
  }

  /// Set Audio Ad Minute
  Future<void> setAudioAdMinute(int minute) {
    return _sharedPreference.then((prefs) {
      return prefs.setInt(_showAudioAdXMinute, minute);
    });
  }

  /// Increment Radio Listening Count
  Future<void> incrementRadioListeningCount() {
    return _sharedPreference.then((prefs) {
      var _count = prefs.getInt(_radioListenCount) ?? 0;
      return prefs.setInt(_radioListenCount, ++_count);
    });
  }

  /// Get Radio Listening Count
  Future<int> getRadioListeningCount() {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(_radioListenCount) ?? 0;
    });
  }

  /// Set Skip Intro
  Future<bool> setSkipIntro(bool value) async {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(_intro, value);
    });
  }

  /// Is Show Intro
  Future<bool> isShowIntro() async {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(_intro) ?? false;
    });
  }

  /// Set First Login
  Future<bool> setFirstLogin(bool value) async {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(_isFirstLogin, value);
    });
  }

  /// Is First Login
  Future<bool> isFirstLogin() async {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(_isFirstLogin) ?? true;
    });
  }

  /// Get Firebase Cloud Messaging Token
  Future<String> getFCMId() async {
    return _sharedPreference.then((prefs) {
      return prefs.getString(_fcmId);
    });
  }

  /// Set Firebase Cloud Messaging Token
  Future<bool> setFCMId(String value) async {
    return _sharedPreference.then((prefs) {
      return prefs.setString(_fcmId, value);
    });
  }

  /// Get Sleeping Time
  Future<DateTime> getSleepingTime() async {
    return _sharedPreference.then((prefs) {
      return prefs.getInt(_sleepingTime) != null ? DateTime.fromMillisecondsSinceEpoch(prefs.getInt(_sleepingTime)) : null;
    });
  }

  /// Set Sleeping Tİme
  Future<bool> setSleepingTime(DateTime value) async {
    return _sharedPreference.then((prefs) {
      return prefs.setInt(_sleepingTime, value.millisecondsSinceEpoch);
    });
  }

  /// Remove Sleeping Time
  Future<void> removeSleepingTime() async {
    return _sharedPreference.then((preference) {
      preference.remove(_sleepingTime);
    });
  }

  /// Remove Sleeping Time
  Future<void> reload() async {
    await (await _sharedPreference).reload();
  }
}
