import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

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
}
