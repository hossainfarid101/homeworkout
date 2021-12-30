import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(Preference.language, languageCode);
  return _locale(languageCode);
}

Locale getLocale() {
  String languageCode =
      Preference.shared.getString(Preference.language) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale('en', '');
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var _locale = await setLocale(selectedLanguageCode);
  MyApp.setLocale(context, _locale);
}
