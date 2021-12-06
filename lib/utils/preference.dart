// Dart imports:
import 'dart:async';

// Package imports:
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* global class for handle all the preference activity into application */

class Preference {
  // Preference key
  static const String authorization = "Authorization";
  static const String fcmToken = "FCM_TOKEN";
  static const String userData = "USER_DATA";
  static const String userId = "USER_ID";
  static const String token = "TOKEN";
  static const String isPurchased = "IS_PURCHASED";
  static const String isNotificationAllowed = "IS_NOTIFICATION_ALLOWED";
  static const String percentage = "PERCENTAGE";
  static const String needToSync = "NEED_TO_SYNC";



  static const String isUserFirsttime = "IS_USER_FIRSTTIME";
  static const String targetDrinkWater = "TARGET_DRINK_WATER";
  static const String selectedDrinkWaterML = "SELECTED_DRINK_WATER_ML";
  static const String isReminderOn = "IS_REMINDER_ON";
  static const String isDistanceIndicatorOn = "IS_DISTANCE_INDICATOR_ON";
  static const String targetvalueForDistanceInKM = "TARGETVALUE_FOR_DISTANCE_IN_KM";
  static const String targetValueForRuntime = "TARGETVALUE_FOR_RUNTIME";
  static const String targetValueForWalktime = "TARGETVALUE_FOR_WALKTIME";
  static const String sliderValue = "SLIDER_VALUE";
  static const String isKMSelected = "IS_KM_SELECTED";
  static const String startTimeReminder = "START_TIME_REMINDER";
  static const String dailyReminderTime = "DAILY_REMINDER_TIME";
  static const String drinkWaterInterval = "DRINK_WATER_INTERVAL";
  static const String dailyReminderRepeatDay = "DAILY_REMINDER_REPEAT_DAY";
  static const String isDailyReminderOn = "IS_DAILY_REMINDER_ON";
  static const String endTimeReminder = "END_TIME_REMINDER";


  static const String metricImperialUnits = "METRIC_IMPERIAL_UNITS";
  static const String language = "LANGUAGE";
  static const String firstDayOfWeek = "FIRST_DAY_OF_WEEK";
  static const String firstDayOfWeekInNum = "FIRST_DAY_OF_WEEK_IN_NUM";

  static const String gender = "GENDER";
  static const String distance = "DISTANCE";
  static const String height = "HEIGHT";
  static const String weight = "WEIGHT";
  static const String totalSteps = "TOTAL_STEPS";
  static const String currentSteps = "CURRENT_STEPS";
  static const String targetSteps = "TARGET_STEPS";
  static const String oldTime = "OLD_TIME";
  static const String oldDistance = "OLD_DISTANCE";
  static const String oldCalories = "OLD_CALORIES";
  static const String calories = "CALORIES";
  static const String date = "DATE";
  static const String isPause = "IS_PAUSE";
  static const String duration = "DURATION";
  static const String isRedirect = "IS_REDIRECT";

  static const String countdownTime ="COUNTDOWN_TIME";
  static const String trainingRestTime = "TRAINING_REST_TIME";
  static const String isMute = "IS_MUTE";
  static const String isCoachTips = "IS_COACH_TIPS";
  static const String isVoiceGuide = "IS_VOICE_GUIDE";
  static const String dateOfBirth = "DATE_OF_BIRTH";
  static const String isMale = "IS_MALE";
/*  static const String isKG = "IS_KG";
  static const String isCM = "IS_CM";*/


  static const String IS_KG = "IS_KG";
  static const String IS_CM = "IS_CM";
  static const String HEIGHT_CM = "HEIGHT_CM";
  static const String HEIGHT_IN = "HEIGHT_IN";
  static const String HEIGHT_FT = "HEIGHT_FT";
  static const String WEIGHT = "WEIGHT";
  static const String PREF_LAST_INPUT_FOOT = "PREF_LAST_INPUT_FOOT";
  static const String PREF_LAST_INPUT_INCH = "PREF_LAST_INPUT_INCH";
  static const String BMI = "BMI";
  static const String BMI_TEXT = "BMI_TEXT";

  static const String PREF_TRAINING_DAY = "PREF_TRAINING_DAY";
  static const String PREF_FIRST_DAY = "PREF_FIRST_DAY";

  static const String DAILY_REMINDER_TIME = "DAILY_REMINDER_TIME";
  static const String IS_DAILY_REMINDER_ON = "IS_DAILY_REMINDER_ON";
  static const String DAILY_REMINDER_REPEAT_DAY = "DAILY_REMINDER_REPEAT_DAY";

  static const String DRAWER_INDEX = "DRAWER_INDEX";



  static const String END_TIME = "END_TIME";

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

  // Array get & set
  List<String>? getStringList(String key) {
    return _pref!.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _pref!.setStringList(key, value);
  }

  /* remove  element from preferences */
  Future<bool> remove(key, [multi = false]) async {
    SharedPreferences? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }

    return Future.value(true);
  }

  /* remove all elements from preferences */
  static Future<bool> clear() async {
    // return await _pref.clear();
    // Except FCM token & device info
    _pref!.getKeys().forEach((key) async {
      if (key != fcmToken && key != isNotificationAllowed) {
        await _pref!.remove(key);
      }
    });

    return Future.value(true);
  }

  static Future<bool> clearTargetDrinkWater() async {
    _pref!.getKeys().forEach((key) async {
      if (key == targetDrinkWater) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearStartTimeReminder() async {
    _pref!.getKeys().forEach((key) async {
      if (key == startTimeReminder) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearEndTimeReminder() async {
    _pref!.getKeys().forEach((key) async {
      if (key == endTimeReminder) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearSelectedDrinkWaterML() async {
    _pref!.getKeys().forEach((key) async {
      if (key == selectedDrinkWaterML) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearMetricAndImperialUnits() async {
    _pref!.getKeys().forEach((key) async {
      if (key == metricImperialUnits) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearLanguage() async {
    _pref!.getKeys().forEach((key) async {
      if (key == language) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }

  static Future<bool> clearFirstDayOfWeek() async {
    _pref!.getKeys().forEach((key) async {
      if (key == firstDayOfWeek) {
        await _pref!.remove(key);
      }
    });
    return Future.value(true);
  }


  setLastUnCompletedExPos(String tableName, int numLastPosition) {
    _pref!.setInt(tableName, numLastPosition);
  }

  int? getLastUnCompletedExPos(String tableName) {
    return _pref!.getInt(tableName) ?? 0;
  }


  setLastUnCompletedExPosForDays(String tableName,String weekName,String dayName, int numLastPosition) {
    _pref!.setInt(tableName+weekName+dayName, numLastPosition);
  }

  int? getLastUnCompletedExPosForDays(String tableName,String weekName,String dayName) {
    return _pref!.getInt(tableName+weekName+dayName) ?? 0;
  }
}
