// Dart imports:
import 'dart:async';

// Package imports:
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* global class for handle all the preference activity into application */

class Preference {
  static const String userId = "USER_ID";

  static const String IS_PURCHASED = "IS_PURCHASED";
  static const SELECTED_FIRST_DAY_OF_WEEK = "SELECTED_FIRST_DAY_OF_WEEK";

  static const String isUserFirsttime = "IS_USER_FIRSTTIME";

  static const String language = "LANGUAGE";

  static const String calories = "CALORIES";
  static const String duration = "DURATION";

  static const String countdownTime = "COUNTDOWN_TIME";
  static const String trainingRestTime = "TRAINING_REST_TIME";
  static const String isMute = "IS_MUTE";
  static const String isCoachTips = "IS_COACH_TIPS";
  static const String isVoiceGuide = "IS_VOICE_GUIDE";
  static const String dateOfBirth = "DATE_OF_BIRTH";
  static const String isMale = "IS_MALE";

  static const String IS_KG = "IS_KG";
  static const String IS_CM = "IS_CM";
  static const String HEIGHT_CM = "HEIGHT_CM";
  static const String HEIGHT_IN = "HEIGHT_IN";
  static const String HEIGHT_FT = "HEIGHT_FT";
  static const String WEIGHT = "WEIGHT";
  static const String BMI = "BMI";
  static const String BMI_TEXT = "BMI_TEXT";

  static const String SELECTED_TRAINING_DAY = "SELECTED_TRAINING_DAY";

  static const String DRAWER_INDEX = "DRAWER_INDEX";

  static const String END_TIME = "END_TIME";

  static const String INTERSTITIAL_AD_COUNT_START = "INTERSTITIAL_AD_COUNT_START";
  static const String INTERSTITIAL_AD_COUNT_QUIT = "INTERSTITIAL_AD_COUNT_QUIT";
  static const String INTERSTITIAL_AD_COUNT_COMPLETE = "INTERSTITIAL_AD_COUNT_COMPLETE";

  // ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static SharedPreferences? _pref;

  /* make connection with preference only once in application */
  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance().then((onValue) {
      _pref = onValue;
    }).catchError((onError) {
      _pref = null;
    });

    return _pref;
  }

  // String get & set
  String? getString(String key) {
    return _pref!.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _pref!.setString(key, value);
  }

  // Int get & set
  int? getInt(String key) {
    return _pref!.getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _pref!.setInt(key, value);
  }

  // Bool get & set
  bool? getBool(String key) {
    return _pref!.getBool(key);
  }

  Future<bool> setBool(String key, bool value) {
    return _pref!.setBool(key, value);
  }

  // Double get & set
  double? getDouble(String key) {
    return _pref!.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _pref!.setDouble(key, value);
  }

  setLastUnCompletedExPos(String tableName, int numLastPosition) {
    _pref!.setInt(tableName, numLastPosition);
  }

  int? getLastUnCompletedExPos(String tableName) {
    return _pref!.getInt(tableName) ?? 0;
  }

  setLastUnCompletedExPosForDays(
      String tableName, String weekName, String dayName, int numLastPosition) {
    _pref!.setInt(tableName + weekName + dayName, numLastPosition);
  }

  int? getLastUnCompletedExPosForDays(
      String tableName, String weekName, String dayName) {
    return _pref!.getInt(tableName + weekName + dayName) ?? 0;
  }

  setLastTime(String tableName, String time) {
    return _pref!.setString(Constant.LAST_TIME + tableName, time);
  }

  String? getLastTime(String tableName) {
    return _pref!.getString(Constant.LAST_TIME + tableName) ?? null;
  }
}
