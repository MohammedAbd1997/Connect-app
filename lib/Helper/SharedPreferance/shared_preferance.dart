import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  SpHelper._();

  static SpHelper spHelper = SpHelper._();

  SharedPreferences? sharedPreferences;

  initSharedPrefrences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  bool getIsLoginFirstTime() {
    bool isFirstTime = sharedPreferences!.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  setIsLoginFirstTime(bool value) {
    sharedPreferences!.setBool('isFirstTime', value);
  }

  setUserId(String id) {
    sharedPreferences!.setString('userId', id);
  }

  getUserId() {
    String userId = sharedPreferences!.getString('userId') ?? '';
    return userId;
  }

  setApiToken(String id) {
    sharedPreferences!.setString('apiToken', id);
  }

  getApiToken() {
    String TokenId = sharedPreferences!.getString('apiToken') ?? '';
    return TokenId;
  }

  setRefreshToken(String id) {
    sharedPreferences!.setString('refreshToken', id);
  }

  getRefreshToken() {
    String TokenId = sharedPreferences!.getString('refreshToken') ?? '';
    return TokenId;
  }

  setSessionId(String id) {
    sharedPreferences!.setString('sessionId', id);
  }

  getSessionId() {
    String TokenId = sharedPreferences!.getString('sessionId') ?? '';
    return TokenId;
  }

  getLanguage() {
    String language = sharedPreferences!.getString('language') ?? 'E';

    return language;
  }

  setLanguage(String language) {
    sharedPreferences!.setString('language', language);
  }

  setTheme({bool isDark = false}) {
    sharedPreferences!.setBool('isDark', isDark);
  }

  bool getTheme() {
    if (sharedPreferences == null) {
      return false;
    }
    bool isFirstTime = sharedPreferences!.getBool('isDark') ?? false;
    return isFirstTime;
  }
}
