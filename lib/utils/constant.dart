
import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:intl/intl.dart';

class Constant {
  static const strMenu = "Menu";
  static const strBack = "Back";
  static const strHistory = "History";
  static const strExerciseReminder = " Exercise Reminder";

/*  static const minKG = 20.00;
  static const maxKG = 997.00;

  static const minLBS = 45.00;
  static const maxLBS = 2200.00;*/

  static const ML_100 = 100;
  static const ML_150 = 150;
  static const ML_250 = 250;
  static const ML_500 = 500;

  static const MIN_KG = 20.00;
  static const MAX_KG = 997.00;

  static const MIN_LBS = 45.00;
  static const MAX_LBS = 2200.00;

  static const MIN_CM = 20.00;
  static const MAX_CM = 400.00;

  static const MIN_INCH = 0.0;
  static const MAX_INCH = 12.0;

  static const MIN_FT = 0.0;
  static const MAX_FT = 14.0;

  static List<MultiSelectDialogItem> daysList = [
    MultiSelectDialogItem("1", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[0]),
    MultiSelectDialogItem("2", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[1]),
    MultiSelectDialogItem("3", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[2]),
    MultiSelectDialogItem("4", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[3]),
    MultiSelectDialogItem("5", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[4]),
    MultiSelectDialogItem("6", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[5]),
    MultiSelectDialogItem("7", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[6]),
  ];
  static const String emailPath = 'fitnessentertainmentapps@gmail.com';

  static String shareLink = "Add the link";//TODO


  static String getPrivacyPolicyURL() {
    return "https://sites.google.com/view/trackerapp-pp/home";
  }

}
