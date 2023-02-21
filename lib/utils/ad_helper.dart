import 'dart:io';

import 'package:homeworkout_flutter/utils/debug.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return "ca-app-pub-2106445418736402/4307320179";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2106445418736402/5716056024";
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
        return "ca-app-pub-2106445418736402/6741911827";
      } else if (Platform.isIOS) {
        return "ca-app-pub-2106445418736402/9176503472";
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get nativeAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-2106445418736402/5428830159';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-2106445418736402/9715010780';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get rewardedAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-2106445418736402/3780157825';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-2106445418736402/5967337461';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

}
