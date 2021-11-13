
import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:intl/intl.dart';

class Constant {
  static const strMenu = "Menu";
  static const strBack = "Back";
  static const strDelete = "DELETE";
  static const strSetting = "Setting";
  static const strSettingCircle = "Setting_circle";
  static const strClose = "CLOSE";
  static const strInfo = "INFO";
  static const strOptions = "OPTIONS";

  static const minKG = 20.00;
  static const maxKG = 997.00;

  static const minLBS = 45.00;
  static const maxLBS = 2200.00;

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

  static String getPrivacyPolicyURL() {
    return "https://sites.google.com/view/trackerapp-pp/home";
  }

}
