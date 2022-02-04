import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeworkout_flutter/database/tables/reminder_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/main.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;

import 'constant.dart';

class Utils {
  static showToast(BuildContext context, String msg,
      {double duration = 2, ToastGravity? gravity}) {
    gravity ??= ToastGravity.BOTTOM;

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: Colur.txtGrey,
        textColor: Colur.white,
        fontSize: 14.0);
  }

  static bool isLogin() {
    var uid = Preference.shared.getString(Preference.userId);
    return (uid != null && uid.isNotEmpty);
  }

  static bool isPurchased() {
    return Preference.shared.getBool(Preference.IS_PURCHASED) ?? false;
  }

  static getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}";
  }

  static getCurrentDateWithTime() {
    return formatDate(
        DateTime.now(), [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
  }

  static getCurrentDate() {
    return DateFormat.yMd().format(DateTime.now());
  }

  static double cmToIn(double heightValue) {
    return double.parse((heightValue / 30.48).toStringAsFixed(1));
  }

  static double lbToKg(double weightValue) {
    return double.parse((weightValue / 2.2046226218488).toStringAsFixed(1));
  }

  static double kgToLb(double weightValue) {
    return double.parse((weightValue * 2.2046226218488).toStringAsFixed(1));
  }

  static double inToCm(double ftValue, double inValue) {
    return double.parse(
        ((ftValue * 30.48) + (inValue * 2.54)).toStringAsFixed(1));
  }

  static String secondToMMSSFormat(int value) =>
      '${formatDecimal(value ~/ 60)}:${formatDecimal(value % 60)}';

  static String formatDecimal(num value) => '$value'.padLeft(2, '0');

  static downLoadTTS() {
    if (Platform.isAndroid) {
      try {
        launch("market://search?q=text to speech&c=apps");
      } on PlatformException {
        launch("http://play.google.com/store/search?q=text to speech&c=apps");
      } finally {
        launch("http://play.google.com/store/search?q=text to speech&c=apps");
      }
    } else {
      try {
        launch("apps://itunes.apple.com/app/apple-store/texttospeech");
      } on PlatformException {
        launch("http://appstore.com/texttospeech");
      } finally {
        launch("http://appstore.com/texttospeech");
      }
    }
  }

  static textToSpeech(String speakText, FlutterTts flutterTts) async {
    if (Platform.isAndroid) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("en-GB");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.isLanguageAvailable("en-GB");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    } else {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("en-AU");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.isLanguageAvailable("en-AU");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    }
  }

  static List<String> getDaysNameOfWeek(int? firstDay) {
    final now = DateTime.now();
    final firstDayOfWeek =
        now.subtract(Duration(days: now.weekday - firstDay!));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(DateFormat.WEEKDAY)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<String> getDaysDateOfWeek(int? firstDay) {
    final now = DateTime.now();
    final firstDayOfWeek =
        now.subtract(Duration(days: now.weekday - firstDay!));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(DateFormat.DAY)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<String> getDaysDateForHistoryOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat("yyyy-MM-dd")
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static String totTitle(String input) {
    final List<String> splitStr = input.split(' ');
    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] =
          '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }
    final output = splitStr.join(' ');
    return output;
  }

  static String getFirstDayOfWeek(BuildContext context, int? selectedDay) {
    String day = "";
    if (selectedDay == 0) {
      day = Languages.of(context)!.txtSunday;
    } else if (selectedDay == 1) {
      day = Languages.of(context)!.txtMonday;
    } else if (selectedDay == -1) {
      day = Languages.of(context)!.txtSaturday;
    }
    return day;
  }

  static String getImageBannerForBodyFocusSubPlan(String planName) {
    String imageName = "";
    if (planName == Constant.PLAN_7_MIN_BUTT_WORKOUT ||
        planName == Constant.PLAN_7_MIN_ABS_WORKOUT) {
      imageName = "ic_7_min_butt_banner.webp";
    } else if (planName == Constant.PLAN_7_MIN_LOSE_ARM_FAT) {
      imageName = "ic_7_min_lose_arm_banner.webp";
    } else if (planName == Constant.PLAN_ARM_WORKOUT_NO_PUSH_UPS) {
      imageName = "ic_arm_workout_no_push_banner.webp";
    } else if (planName == Constant.PLAN_BELLY_FAT_BURNER_HIIT_INTERMEDIATE ||
        planName == Constant.PLAN_BELLY_FAT_BURNER_HIIT) {
      imageName = "ic_belly_fat_burner_banner.webp";
    } else if (planName == Constant.PLAN_BUILD_WIDER_SHOULDERS) {
      imageName = "ic_build_wider_banner.webp";
    } else if (planName == Constant.PLAN_BUTT_BLASTER_CHALLENGE) {
      imageName = "ic_butt_blaster_banner.webp";
    } else if (planName == Constant.PLAN_GET_RID_OF_MAN_BOOBS_HIIT) {
      imageName = "ic_get_rid_of_man_banner.webp";
    } else if (planName == Constant.PLAN_INTENSE_INNER_THIGH_CHALLENGE) {
      imageName = "ic_intense_inner_banner.webp";
    } else if (planName == Constant.PLAN_KILLER_CHEST_WORKOUT) {
      imageName = "ic_killeR_chest_banner.webp";
    } else if (planName == Constant.PLAN_HIIT_KILLER_CORE) {
      imageName = "ic_killer_core_hiit_banner.webp";
    } else if (planName == Constant.PLAN_LEGS_BUTT_WORKOUT) {
      imageName = "ic_leg_butt_workout_banner.webp";
    } else if (planName == Constant.PLAN_LEG_WORKOUT_NO_JUMPING) {
      imageName = "ic_leg_workout_no_jump_banner.webp";
    } else if (planName == Constant.PLAN_ONLY_4_MOVES_FOR_ABS) {
      imageName = "ic_only_4_move_banner.webp";
    } else if (planName == Constant.PLAN_PLANK_CHALLENGE) {
      imageName = "ic_plank_banner.webp";
    } else if (planName == Constant.PLAN_RIPPED_V_CUT_ABS_SCULPTING) {
      imageName = "ic_ripped_vcut_banner.webp";
    }
    return "assets/exerciseImage/discover/subPlanBanner/" + imageName;
  }

  static Future<void> saveReminder({List<ReminderTable>? reminderList}) async {
    int notificationId = 100;
    List selectedDays = [];
    TimeOfDay? selectedTime;

    List<PendingNotificationRequest> pendingNoti =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    pendingNoti.forEach((element) {
      if (element.payload == Constant.strExerciseReminder) {
        flutterLocalNotificationsPlugin.cancel(element.id);
      }
    });

    reminderList!.forEach((element) {
      selectedDays = element.repeatNo!.split(", ");
      var hr = int.parse(element.time!.split(":")[0]);
      var min = int.parse(element.time!.split(":")[1]);
      selectedTime = TimeOfDay(hour: hr, minute: min);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
          now.day, selectedTime!.hour, selectedTime!.minute);

      if (element.isActive == "true") {
        selectedDays.forEach((element) async {
          notificationId += 1;
          if (int.parse(element as String) == DateTime.now().weekday &&
              DateTime.now().isBefore(scheduledDate)) {
            await scheduledNotification(scheduledDate, notificationId);
          } else {
            var tempTime = scheduledDate.add(const Duration(days: 1));
            while (tempTime.weekday != int.parse(element)) {
              tempTime = tempTime.add(const Duration(days: 1));
            }
            await scheduledNotification(tempTime, notificationId);
          }
        });
      }
    });
  }

  static scheduledNotification(
      tz.TZDateTime scheduledDate, int notificationId) async {
    var titleText = "Exercise Reminder";
    var msg = "It's time to exercise.";

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        titleText,
        msg,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'exercise_reminder', 'Exercise Reminder',
              channelDescription: 'This is reminder for exercise',
              icon: 'ic_notification'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: Constant.strExerciseReminder);
  }

  static nonPersonalizedAds()  {
    if(Platform.isIOS) {
      if (Preference.shared.getString(Preference.TRACK_STATUS) != Constant.trackingStatus) {
        return true;
      } else {
        return false;
      }
    }else {
      return false;
    }
  }
}
