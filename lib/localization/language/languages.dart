import 'package:flutter/material.dart';

abstract class Languages {

  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get txtDeviceTTSSetting;

  String get txtDownloadTTSEngine;

  String get txtSelectTTSEngine;

  String get txtTestVoice;

  String get txtCommunity;

  String get txtCountdownTime;

  String get txtGeneralSettings;

  String get txtHealthData;

  String  get txtMetricImperialUnit;

  String  get txtRateUs;

  String  get txtSecs;

  String get txtShareWithFriends;

  String get txtSoundOptions;

  String get txtSupportUs;

  String get txtTrainingrest;

  String get txtVoiceOptions;

  String get txtFeedBack;

  String get txtPrivacyPolicy;

  String get txtDiscover;

  String get txtReminder;

  String get txtSettings;

  String get txtRestartProgress;

  String get txtWorkout;

  String get txtKcal;

  String get txtDuration;

  String get txtReport;

  String get txtTrainingPlans;

  String get txtGood;

  String get txtOkay;

  String get txtRate;

  String get txtTerrible;

  String get txtBad;

  String get txtGreat;

  String get txtRatingOnGooglePlay;

  String get txtBestWeCanGet;

  String get txtKG;

  String get txtLB;

  String get txtCancel;

  String get txtWarningForKg;

  String get txtWarningForLbs;

  String get txtSave;

  String get txtHomeWorkout;

  String get txtWeekGoal;

  String get txtWeekGoalDesc;

  String get txtSetAGoal;

  String get txt7X4Challenge;

  String get txtFullBody;

  String get txtLowerBody;

  String get txtDaysLeft;

  String get txtBeginner;

  String get txtAbsBeginner;

  String get txtChestBeginner;

  String get txtArmBeginner;

  String get txtLegBeginner;

  String get txtShoulderBackBeginner;
}
