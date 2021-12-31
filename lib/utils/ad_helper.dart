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

  static String get nativeAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/2247696110';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/3986624511';
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
        return 'ca-app-pub-3940256099942544/5224354917';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get appOpenAdUnitId {
    if (Debug.GOOGLE_AD) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/3419835294';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/5662855259';
      } else {
        throw new UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }
}
