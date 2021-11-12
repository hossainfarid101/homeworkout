import 'dart:developer';

class Debug {
  static const debug = true;

  static printLog(String str) {
    if (debug) log(str);
  }
}