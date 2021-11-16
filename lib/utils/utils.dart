import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static getCurrentDateTime() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}";
  }

  static getCurrentDate() {
    return DateFormat.yMd().format(DateTime.now());
  }

  static getCurrentDayTime() {
    return DateFormat.jm().format(DateTime.now());
  }

  static double lbToKg(double weightValue) {
    return double.parse((weightValue / 2.2046226218488).toStringAsFixed(1));
  }

  static double kgToLb(double weightValue) {
    return double.parse((weightValue * 2.2046226218488).toStringAsFixed(1));
  }

  static int daysInMonth(final int monthNum, final int year) {
    List<int> monthLength = List.filled(12, 0, growable: true);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true) {
      monthLength[1] = 29;
    } else {
      monthLength[1] = 28;
    }

    return monthLength[monthNum - 1];
  }

  static bool leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }

    return leapYear;
  }

  static String secToString(int sec) {
    var formatter = NumberFormat("00");
    var p1 = sec % 60;
    var p2 = sec / 60;
    var p3 = p2 % 60;             
    p2 /= 60;

    return formatter.format(p2) +
        ":" +
        formatter.format(p3) +
        ":" +
        formatter.format(p1);
  }

  static String secondToMMSSFormat(int value) =>
      '${formatDecimal(value ~/ 60)}:${formatDecimal(value % 60)}';

  static String formatDecimal(num value) => '$value'.padLeft(2, '0');

  static double mileToKm(double mile){

  double km = mile*1.609;

    return km;
  }

  static double kmToMile(double km){

    double mile = km/1.609;

    return mile;
  }
  static double minPerKmToMinPerMile(double speedInKm){

    double speedInmMile = speedInKm * 1.609;

    return speedInmMile;
  }

  static double calculationForHeartHealthGraph(int walkTime,int runTime,int targetWalkTime,int targetRunTime){
    double walkTimeInMin = Utils.secToMin(walkTime);
    double runTimeInMin = Utils.secToMin(runTime);
    double avgWalk = (100*walkTimeInMin)/targetWalkTime;
    double avgRun = (100*runTimeInMin)/targetRunTime;
    double total = (avgWalk+avgRun)/2;

    return total;
  }

  static double secToHour(int sec) {
    double hrs = sec/3600;
    return hrs;
  }

  static double secToMin(int sec) {
    double mins = sec/60;
    return mins;
  }

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
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.isLanguageAvailable("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    }
  }


  static List<String> getDaysNameOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(DateFormat.WEEKDAY)
        .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<String> getDaysDateOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday));
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

}
