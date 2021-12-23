import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get txtSedentary;

  String get txtDesSedentary;

  String get txtLightlyActive;

  String get txtDesLightlyActive;

  String get txtModeratelyActive;

  String get txtDesModeratelyActive;

  String get txtVeryActive;

  String get txtDesVeryActive;

  String get txt3to5PushUps;

  String get txt5to10PushUps;

  String get txtAtLeast10;

  String get txtFeelConfident;

  String get txtReleaseStress;

  String get txtImproveHealth;

  String get txtBoostEnergy;

  String get txtLoseWeight;

  String get txtBuildMuscle;

  String get txtKeepFit;

  String get txtArm;

  String get txtChest;

  String get txtAbs;

  String get txtLeg;

  String get txtPleaseChooseYourFocusArea;

  String get txtWhatAreYourMainGoals;

  String get txtWhatMotivatesYouTheMost;

  String get txtHowManyPushUpsCan;

  String get txtWhatsYourActivityLevel;

  String get txSetYourWeeklyGoal;

  String get txtWeRecommendTraining;

  String get txtLetUsKnowYouBetterToHelp;

  String get txtGeneratingThePlan;

  String get txtPreparingYourPlan;

  String get txtYourPlanIsReady;

  String get txtWeHaveSelectedThisPlan;

  String get txtGetMyPlan;

  String get txtStartNow;

  String get txtLetUsKnowYouBetter;

  String get txtWhatsYourGender;

  String get txtShare;

  String get txtNext;

  String get txtExercises;

  String get txtCompleted;

  String get txtDay;

  String get txtDailyReminder;

  String get txtExerciseReminder;

  String get txtRepeat;

  String get txtMin;

  String get txtFastWorkout;

  String get txtPicksForYou;

  String get txtBodyFocus;

  String get txtSleep;

  String get txtWithEquipment;

  String get txtChallenge;

  String get txtForBeginners;

  String get txtQuarantineAtHome;

  String get txtStart;

  String get txtWorkouts;

  String get txtMins;

  String get txtWeightUnit;

  String get txtHeightUnit;

  String get txtCM;

  String get txtINCH;

  String get txtHeight;

  String get txtWeight;

  String get txtGender;

  String get txtBirthYear;

  String get txtFemale;

  String get txtMale;

  String get txtTestVoiceTts;

  String get txtHearTestVoice;

  String get txtYes;

  String get txtNo;

  String get txtUnableToHearVoiceDesc;

  String get txtChooseVoice;

  String get txtGoogleSpeech;

  String get txtCountdownTimeDialogHeading;

  String get txtTrainingRestTimeDialogHeading;

  String get txtCoachTipsDesc;

  String get txtCoachTips;

  String get txtMute;

  String get txtOk;

  String get txtSet;

  String get txtVoiceGuide;

  String get txtHomeWorkoutFeedbackiOS;

  String get txtHomeWorkoutFeedbackAndroid;

  String get txtShareDesc;

  String get txtDeviceTTSSetting;

  String get txtDownloadTTSEngine;

  String get txtSelectTTSEngine;

  String get txtTestVoice;

  String get txtCommunity;

  String get txtCountdownTime;

  String get txtGeneralSettings;

  String get txtHealthData;

  String get txtMetricImperialUnit;

  String get txtRateUs;

  String get txtSecs;

  String get txtShareWithFriends;

  String get txtSoundOptions;

  String get txtSupportUs;

  String get txtTrainingRest;

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

  String get txtMoreWorkout;

  String get txtGo;

  String get txtweek;

  String get txtMinute;

  String get txtHistory;

  String get txtRecords;

  String get txtCurrent;

  String get txtHeaviest;

  String get txtLightest;

  String get txtBmiKg;

  String get txtheight;

  String get txtIn;

  String get txtWarningForCm;

  String get txtWarningForInch;

  String get txtSeverelyUnderweight;

  String get txtVeryUnderweight;

  String get txtUnderweight;

  String get txtOverWeight;

  String get txtModeratelyObese;

  String get txtVeryObese;

  String get txtSeverelyObese;

  String get txtObese;

  String get txtHealthyWeight;

  String get txtBeginnerDay;

  String get txtIntermediate;

  String get txtIntermediateDay;

  String get txtAdvance;

  String get txtAdvanceDay;

  String get txtDelete;

  String get txtDeleteExe;

  String get txtSetWeeklyGoal;

  String get txtSetGoalDesc;

  String get txtWeeklyTrainingDays;

  String get txtFirstDayOfWeek;

  String get txtSunday;

  String get txtMonday;

  String get txtSaturday;

  String get txtClose;

  String get txtWeek;

  String get txtBMI;

  String get txtEasy;

  String get txtIFeel;

  String get txtExhausted;

  String get txtSkip;

  String get txtRest;

  String get txtDone;

  String get txtPrevious;

  String get txtReadyToGo;

  String get txtAnimation;

  String get txtVideo;

  String get txtPause;

  String get txtRestartThisExercise;

  String get txtQuit;

  String get txtResume;

  String get txtBestQuarantine;

  String get txtSeconds;

  String get txtTimes;

  String get txtNextExercise;

  String get txtDayLeft;

  String get txtSelectingTargetedWorkoutsForYou;

  String get txtFT;

  String get txtInstruction;

  String get txtGotoHomePage;

  String get txtWatchVideoToUnlock;

  String get txtWatchVideoToUnlockDesc;

  String get txtUnlockOnce;

  String get txtFreeTrialDesc;

  String get txtFree7DaysTrial;

  String get txt1month;

  String get txtRemoveAds;

  String get txtUnlimitedWorkout;

  String get txt300PlusWorkout;

  String get txtAddNewWorkoutConstant;

  String get txtGoPremium;

  String get txtExitMessage;

  String get txtWarningForBMIDialog;

  String get txtLastTime;

  String get txtExerciseDayWarning;
}
