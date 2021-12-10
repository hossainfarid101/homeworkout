
import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:intl/intl.dart';

class Constant {

  static const PREF_INTRODUCTION_FINISH = "PREF_INTRODUCTION_FINISH";
  static const SELECTED_YOUR_FOCUS_AREA = "SELECTED_YOUR_FOCUS_AREA";
  static const SELECTED_MAIN_GOALS = "SELECTED_MAIN_GOALS";
  static const SELECTED_MOTIVATES_YOU = "SELECTED_MOTIVATES_YOU";
  static const SELECTED_HOW_MANY_PUSH_UPS = "SELECTED_HOW_MANY_PUSH_UPS";
  static const SELECTED_ACTIVITY_LEVEL = "SELECTED_ACTIVITY_LEVEL";

  static const SELECTED_GENDER = "SELECTED_GENDER";
  static const GENDER_MEN = "men";
  static const GENDER_WOMEN = "women";
  static const QUARANTINE_AT_HOME = "Quarantine at home";

  static const PAGE_HISTORY = "PAGE_HISTORY";
  static const PAGE_DISCOVER = "PAGE_DISCOVER";
  static const PAGE_HOME = "PAGE_HOME";
  static const PAGE_QUARANTINE = "PAGE_QUARANTINE";
  static const PAGE_DAYS_STATUS = "PAGE_DAYS_STATUS";

  static const strMenu = "Menu";
  static const strBack = "Back";
  static const strHistory = "History";
  static const strExerciseReminder = " Exercise Reminder";

  static const strBeginner = "Beginner";
  static const strIntermediate = "Intermediate";
  static const strAdvance = "Advance";

  static const tbl_full_body_workouts_list = "tbl_full_body_workouts_list";
  static const tbl_lower_body_list = "tbl_lower_body_list";
  static const tbl_bw_exercise = "tbl_bw_exercise";

  static const tbl_chest_advanced = "tbl_chest_advanced";
  static const tbl_chest_beginner = "tbl_chest_beginner";
  static const tbl_chest_intermediate = "tbl_chest_intermediate";

  static const tbl_abs_advanced = "tbl_abs_advanced";
  static const tbl_abs_beginner = "tbl_abs_beginner";
  static const tbl_abs_intermediate = "tbl_abs_intermediate";

  static const tbl_arm_advanced = "tbl_arm_advanced";
  static const tbl_arm_beginner = "tbl_arm_beginner";
  static const tbl_arm_intermediate = "tbl_arm_intermediate";

  static const tbl_leg_advanced = "tbl_leg_advanced";
  static const tbl_leg_beginner = "tbl_leg_beginner";
  static const tbl_leg_intermediate = "tbl_leg_intermediate";

  static const tbl_shoulder_back_advanced = "tbl_shoulder_back_advanced";
  static const tbl_shoulder_back_beginner = "tbl_shoulder_back_beginner";
  static const tbl_shoulder_back_intermediate = "tbl_shoulder_back_intermediate";

  /* Todo home category static*/
  static const titleQuarantineAtHome = "Quarantine At Home";
  static const title = "title";
  static const txt_7_4_challenge = "7 X 4 Challenge";
  static const Build_wider = "Build Wider";
  static const full_body = "full_data";
  static const biginner = "biginner";
  static const intermediate = "intermediate";
  static const advance = "advance";
  static const Full_body_small = "Full body";
  static const Lower_body_small = "Lower body";
  static const Full_Body = "Full Body";
  static const Lower_Body = "Lower Body";
  static const Chest = "Chest";
  static const Abs = "Abs";
  static const Arm = "Arm";
  static const Shoulder_and_Back = "Shoulder & Back";
  static const Leg = "Leg";
  static const Library = "Library";

  static const catPickForYou = "Picks for you";
  static const catForBeginner = "For beginner";
  static const catFastWorkout = "Fast workout";
  static const catChallenge = "Challenge";
  static const catWithEqipment = "With eqipment";
  static const catSleep = "Sleep";
  static const catBodyFocus = "Body focus";
  static const catQuarantineAtHome = "Quarantine at home";

  static const PREF_RANDOM_DISCOVER_PLAN = "PREF_RANDOM_DISCOVER_PLAN";
  static const PREF_RANDOM_DISCOVER_PLAN_DATE = "PREF_RANDOM_DISCOVER_PLAN_DATE";
  static const EXERCISE_EXTENSION = ".webp";

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
