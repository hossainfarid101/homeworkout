import 'package:homeworkout_flutter/common/multiselectdialog/multiselect_dialog.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:intl/intl.dart';

class Constant {
  static const PLAN_7_MIN_BUTT_WORKOUT = "7 min butt workout";
  static const PLAN_7_MIN_LOSE_ARM_FAT = "7 min lose arm fat";
  static const PLAN_ARM_WORKOUT_NO_PUSH_UPS = "Arm workout (NO PUSH-UPS!)";
  static const PLAN_BELLY_FAT_BURNER_HIIT_INTERMEDIATE =
      "Belly fat burner HIIT intermediate";
  static const PLAN_BUILD_WIDER_SHOULDERS = "Build wider shoulders";
  static const PLAN_BUTT_BLASTER_CHALLENGE = "Butt blaster challenge";
  static const PLAN_GET_RID_OF_MAN_BOOBS_HIIT = "Get rid of man boobs HIIT";
  static const PLAN_INTENSE_INNER_THIGH_CHALLENGE =
      "Intense inner thigh challenge";
  static const PLAN_KILLER_CHEST_WORKOUT = "Killer chest workout";
  static const PLAN_HIIT_KILLER_CORE = "HIIT Killer core";
  static const PLAN_LEGS_BUTT_WORKOUT = "Legs & butt workout";
  static const PLAN_LEG_WORKOUT_NO_JUMPING = "Leg workout (NO JUMPING)";
  static const PLAN_ONLY_4_MOVES_FOR_ABS = "ONLY 4 moves for abs";
  static const PLAN_PLANK_CHALLENGE = "Plank Challenge";
  static const PLAN_RIPPED_V_CUT_ABS_SCULPTING = "Ripped v-cut abs sculpting";
  static const PLAN_BELLY_FAT_BURNER_HIIT = "Belly fat burner HIIT";
  static const PLAN_7_MIN_ABS_WORKOUT = "7 min abs workout";

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
  static const strAdvance = "Advanced";

  static const tbl_full_body_workouts_list = "tbl_full_body_workouts_list";
  static const tbl_lower_body_list = "tbl_lower_body_list";

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
  static const tbl_shoulder_back_intermediate =
      "tbl_shoulder_back_intermediate";

  static const titleQuarantineAtHome = "Quarantine At Home";
  static const title = "title";
  static const txt_7_4_challenge = "7X4 Challenge";
  static const Full_body_small = "Full body";
  static const Lower_body_small = "Lower body";

  static const catDiscoverCard = "Discover card";
  static const catPickForYou = "Picks for you";
  static const catForBeginner = "For beginner";
  static const catFastWorkout = "Fast workout";
  static const catChallenge = "Challenge";
  static const catWithEquipment = "With equipment";
  static const catSleep = "Sleep";
  static const catBodyFocus = "Body focus";
  static const catQuarantineAtHome = "Quarantine at home";

  static const PREF_RANDOM_DISCOVER_PLAN = "PREF_RANDOM_DISCOVER_PLAN";
  static const PREF_RANDOM_DISCOVER_PLAN_DATE =
      "PREF_RANDOM_DISCOVER_PLAN_DATE";
  static const EXERCISE_EXTENSION = ".webp";

  static const LAST_TIME = "LAST_TIME";

  static const BEGINNER = "Beginner";
  static const INTERMEDIATE = "Intermediate";
  static const ADVANCED = "Advanced";

  static const MIN_KG = 20.00;
  static const MAX_KG = 997.00;

  static const MIN_LBS = 45.00;
  static const MAX_LBS = 2200.00;

  static const MIN_CM = 20.00;
  static const MAX_CM = 400.00;

  static const MIN_FT = 0.0;
  static const MAX_FT = 14.0;

  static bool isTrainingScreen = false;
  static bool isDiscoverScreen = false;
  static bool isReportScreen = false;
  static bool isReminderScreen = false;
  static bool isSettingsScreen = false;

  static List<MultiSelectDialogItem> daysList = [
    MultiSelectDialogItem(
        "1", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[1]),
    MultiSelectDialogItem(
        "2", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[2]),
    MultiSelectDialogItem(
        "3", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[3]),
    MultiSelectDialogItem(
        "4", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[4]),
    MultiSelectDialogItem(
        "5", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[5]),
    MultiSelectDialogItem(
        "6", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[6]),
    MultiSelectDialogItem(
        "7", DateFormat.EEEE(getLocale().languageCode).dateSymbols.WEEKDAYS[0]),
  ];
  static const String emailPath = 'Add your email address here';

  static String shareLink = "Add your app link here";

  static String getPrivacyPolicyURL() {
    return "Add your privacy policy link here";
  }
}
