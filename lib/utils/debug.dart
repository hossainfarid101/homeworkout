import 'dart:developer';

class Debug {
  static const debug = true;
  static const SANDBOX_VERIFY_RECEIPT_URL = true;

  static printLog(String str) {
    if (debug) log(str);
  }
}