import 'dart:io';

import 'package:homeworkout_flutter/utils/debug.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get interstitialAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/8691691433";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/5135589807";
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }
}
