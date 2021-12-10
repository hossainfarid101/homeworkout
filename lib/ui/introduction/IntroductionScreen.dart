import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';

import 'ChooseYourFocusAreaScreen.dart';
import 'GenderSelectionScreen.dart';
import 'GeneratingThePlanScreen.dart';
import 'MainGoalsScreen.dart';
import 'MotivatesYouScreen.dart';
import 'PushUpsCanYouDoScreen.dart';
import 'SetYourIntroWeeklyGoalScreen.dart';
import 'WeightHeightSelectionScreen.dart';
import 'YourActivityLevelScreen.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController pageController = new PageController(initialPage: 0);

  String? mainTitle;
  String? subTitle;

  double? updateValue;
  int currentPageIndex = 0;

  List<dynamic> prefChooseYourFocusAreaList = [];
  List<dynamic> prefMainGoalsList =[];
  List<dynamic> prefMotivatesYouMostList = [];
  String? prefHowManyPushUps;
  String?  prefActivityLevel;
  bool? isPlanReady = false;
  DiscoverPlanTable? randomPlanData;

  @override
  void initState() {
    updateValue = 0.1111111111;
    _getPrefData();
    super.initState();
  }

  _getPrefData() {
    prefChooseYourFocusAreaList.clear();
    var prefChooseYourFocusAreaValue = Preference.shared.getString(Constant.SELECTED_YOUR_FOCUS_AREA) ?? [].toString();
    prefChooseYourFocusAreaList = json.decode(prefChooseYourFocusAreaValue);

    prefMainGoalsList.clear();
    var prefMainGoalsValue = Preference.shared.getString(Constant.SELECTED_MAIN_GOALS) ?? [].toString();
    prefMainGoalsList = json.decode(prefMainGoalsValue);

    prefMotivatesYouMostList.clear();
    var prefMotivatesYouMostValue = Preference.shared.getString(Constant.SELECTED_MOTIVATES_YOU) ?? [].toString();
    prefMotivatesYouMostList = json.decode(prefMotivatesYouMostValue);

     prefActivityLevel = Preference.shared.getString(Constant.SELECTED_ACTIVITY_LEVEL) ?? "Sedentary";


    prefHowManyPushUps = Preference.shared.getString(Constant.SELECTED_HOW_MANY_PUSH_UPS) ?? "Beginner";
  }

  @override
  Widget build(BuildContext context) {
    if (mainTitle == null)
      mainTitle = Languages.of(context)!.txtWhatsYourGender.toUpperCase();
    if (subTitle == null)
      subTitle = Languages.of(context)!.txtLetUsKnowYouBetter;

    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: Scaffold(
        backgroundColor: Colur.white,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(),
              _titleWidget(),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });

                    if (index == 0) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatsYourGender
                            .toUpperCase();
                        subTitle = Languages.of(context)!.txtLetUsKnowYouBetter;
                      });
                    } else if (index == 1) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtPleaseChooseYourFocusArea
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 2) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatAreYourMainGoals
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 3) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatMotivatesYouTheMost
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 4) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtHowManyPushUpsCan
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 5) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtWhatsYourActivityLevel
                            .toUpperCase();
                        subTitle = "";
                      });
                    } else if (index == 6) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtSetWeeklyGoal
                            .toUpperCase();
                        subTitle =
                            Languages.of(context)!.txtWeRecommendTraining;
                      });
                    } else if (index == 7) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtLetUsKnowYouBetter
                            .toUpperCase();
                        subTitle =
                            Languages.of(context)!.txtLetUsKnowYouBetterToHelp;
                      });
                    } else if (index == 8) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtGeneratingThePlan
                            .toUpperCase();
                        subTitle = Languages.of(context)!.txtPreparingYourPlan;
                      });
                    } else if (index == 9) {
                      setState(() {
                        mainTitle = Languages.of(context)!
                            .txtYourPlanIsReady
                            .toUpperCase();
                        subTitle =
                            Languages.of(context)!.txtWeHaveSelectedThisPlan;
                      });
                    }
                  },
                  children: <Widget>[
                    GenderSelectionScreen(),
                    ChooseYourFocusAreaScreen(prefChooseYourFocusAreaList),
                    MainGoalsScreen(prefMainGoalsList),
                    MotivatesYouScreen(prefMotivatesYouMostList),
                    PushUpsCanYouDoScreen(prefHowManyPushUps,(value){
                      prefHowManyPushUps = value;
                      setState(() { });
                    }),
                    YourActivityLevelScreen(prefActivityLevel, (value){
                      prefActivityLevel = value;
                      setState(() { });
                    }),
                    SetYourIntroWeeklyGoalScreen(),
                    WeightHeightSelectionScreen(),
                    GeneratingThePlanScreen(isPlanReady, (value) {
                      setState(() {
                        isPlanReady = value;
                        if(!isPlanReady!) {
                          mainTitle = Languages.of(context)!
                              .txtGeneratingThePlan
                              .toUpperCase();
                          subTitle =
                              Languages.of(context)!.txtPreparingYourPlan;
                        }else{
                          mainTitle = Languages.of(context)!
                              .txtYourPlanIsReady
                              .toUpperCase();
                          subTitle =
                              Languages.of(context)!.txtWeHaveSelectedThisPlan;
                        }
                      });
                    },(value){
                      setState(() {
                        randomPlanData = value;
                      });
                    }),
                  ],
                ),
              ),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  _topBar() {
    return Column(
      children: [
        Row(
          children: [
            if (currentPageIndex != 0 && currentPageIndex != 8) ...{
              InkWell(
                onTap: () {
                  pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                  setState(() {
                    updateValue = updateValue! - 0.1111111111;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 22,
                    color: Colur.darkBlueColor,
                  ),
                ),
              ),
            },
            Expanded(child: Container()),
            if (currentPageIndex != 8) ...{
              InkWell(
                onTap: () {
                  Preference.shared.setBool(Constant.PREF_INTRODUCTION_FINISH, true);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/training", (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(11.5),
                  child: Text(
                    Languages.of(context)!.txtSkip,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colur.darkBlueColor),
                  ),
                ),
              ),
            },
          ],
        ),
        if (currentPageIndex != 8) ...{
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              child: LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colur.darkBlueColor),
                value: updateValue,
                backgroundColor: Colur.unSelectedProgressColor,
                minHeight: 4,
                semanticsValue: '10',
              ),
            ),
          ),
        }
      ],
    );
  }

  _titleWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 18.0, bottom: 25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              mainTitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colur.txtBlack,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              subTitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colur.txtBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _nextButton() {
    return Column(
      children: [
        Visibility(
          visible: currentPageIndex == 8 ? isPlanReady! : true,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              setState(() {
                updateValue = updateValue! + 0.1111111111;
              });

              if (currentPageIndex == 1) {
                Preference.shared.setString(Constant.SELECTED_YOUR_FOCUS_AREA,
                    json.encode(prefChooseYourFocusAreaList));
              } else if (currentPageIndex == 2) {
                Preference.shared.setString(Constant.SELECTED_MAIN_GOALS,
                    json.encode(prefMainGoalsList));
              }else if (currentPageIndex == 3) {
                Preference.shared.setString(Constant.SELECTED_MOTIVATES_YOU,
                    json.encode(prefMotivatesYouMostList));
              }else if (currentPageIndex == 4) {
                Debug.printLog(prefHowManyPushUps!);
                Preference.shared.setString(Constant.SELECTED_HOW_MANY_PUSH_UPS, prefHowManyPushUps!);
              }else if (currentPageIndex == 5) {
                Preference.shared.setString(Constant.SELECTED_ACTIVITY_LEVEL, prefActivityLevel!);
              } else if (currentPageIndex == 8) {
                Preference.shared.setBool(Constant.PREF_INTRODUCTION_FINISH, true);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrainingScreen()), (route) => false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseListScreen(
                            fromPage: Constant.PAGE_DISCOVER,
                            planName: randomPlanData!.planName,
                            discoverPlanTable: randomPlanData
                        )));
              }
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 60.0, vertical: (isPlanReady!)?0.0:30.0),
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                gradient: LinearGradient(
                    colors: [
                      Colur.blueGradient1,
                      Colur.blueGradient2,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                  (currentPageIndex == 8 && isPlanReady!)?Languages.of(context)!.txtStartNow.toUpperCase():
                  Languages.of(context)!.txtNext.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colur.white),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 22,
                      color: Colur.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isPlanReady!,
          child: InkWell(
            onTap:() {
              Preference.shared.setBool(Constant.PREF_INTRODUCTION_FINISH, true);
              Navigator.pushNamedAndRemoveUntil(
                  context, "/training", (route) => false);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                Languages.of(context)!.txtGotoHomePage,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
