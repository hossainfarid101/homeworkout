import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/reminder_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

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

  double? updateValue;
  int currentPageIndex = 0;

  List<dynamic> prefChooseYourFocusAreaList = [];
  List<dynamic> prefMainGoalsList = [];
  List<dynamic> prefMotivatesYouMostList = [];
  String? prefHowManyPushUps;
  String? prefActivityLevel;
  bool? isPlanReady = false;
  DiscoverPlanTable? randomPlanData;
  List<ReminderTable>? reminderList;

  @override
  void initState() {
    updateValue = 0.125;
    _getPrefData();
    super.initState();
  }

  _getPrefData() async {
    prefChooseYourFocusAreaList.clear();
    var prefChooseYourFocusAreaValue =
        Preference.shared.getString(Constant.SELECTED_YOUR_FOCUS_AREA) ??
            [].toString();
    prefChooseYourFocusAreaList = json.decode(prefChooseYourFocusAreaValue);

    prefMainGoalsList.clear();
    var prefMainGoalsValue =
        Preference.shared.getString(Constant.SELECTED_MAIN_GOALS) ??
            [].toString();
    prefMainGoalsList = json.decode(prefMainGoalsValue);

    prefMotivatesYouMostList.clear();
    var prefMotivatesYouMostValue =
        Preference.shared.getString(Constant.SELECTED_MOTIVATES_YOU) ??
            [].toString();
    prefMotivatesYouMostList = json.decode(prefMotivatesYouMostValue);

    prefActivityLevel =
        Preference.shared.getString(Constant.SELECTED_ACTIVITY_LEVEL) ??
            "Sedentary";

    prefHowManyPushUps =
        Preference.shared.getString(Constant.SELECTED_HOW_MANY_PUSH_UPS) ??
            "Beginner";

    reminderList = await DataBaseHelper().getReminderData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colur.white,
              elevation: 0,
            )),
        backgroundColor: Colur.white,
        body: SafeArea(
          child: Column(
            children: [
              _topBar(),
              Expanded(
                child: Center(
                  child: PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      setState(() {
                        currentPageIndex = index;
                      });
                    },
                    children: <Widget>[
                      GenderSelectionScreen(),
                      ChooseYourFocusAreaScreen(prefChooseYourFocusAreaList),
                      MainGoalsScreen(prefMainGoalsList),
                      MotivatesYouScreen(prefMotivatesYouMostList),
                      PushUpsCanYouDoScreen(prefHowManyPushUps, (value) {
                        prefHowManyPushUps = value;
                        setState(() {});
                      }),
                      YourActivityLevelScreen(prefActivityLevel, (value) {
                        prefActivityLevel = value;
                        setState(() {});
                      }),
                      SetYourIntroWeeklyGoalScreen(),
                      WeightHeightSelectionScreen(),
                      GeneratingThePlanScreen(isPlanReady, (value) {
                        setState(() {
                          isPlanReady = value;
                        });
                      }, (value) {
                        setState(() {
                          randomPlanData = value;
                        });
                      }, reminderList),
                    ],
                  ),
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
    return Visibility(
      visible: currentPageIndex != 8,
      child: Column(
        children: [
          Row(
            children: [
              currentPageIndex != 0
                  ? InkWell(
                      onTap: () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          updateValue = updateValue! - 0.125;
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
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 22,
                        color: Colur.white,
                      ),
                    ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: LinearProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colur.darkBlueColor),
                      value: updateValue,
                      backgroundColor: Colur.unSelectedProgressColor,
                      minHeight: 4,
                      semanticsValue: '10',
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Utils.saveReminder(reminderList: reminderList);
                  Preference.shared
                      .setBool(Constant.PREF_INTRODUCTION_FINISH, true);
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
            ],
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
                updateValue = updateValue! + 0.125;
              });

              if (currentPageIndex == 1) {
                Preference.shared.setString(Constant.SELECTED_YOUR_FOCUS_AREA,
                    json.encode(prefChooseYourFocusAreaList));
              } else if (currentPageIndex == 2) {
                Preference.shared.setString(Constant.SELECTED_MAIN_GOALS,
                    json.encode(prefMainGoalsList));
              } else if (currentPageIndex == 3) {
                Preference.shared.setString(Constant.SELECTED_MOTIVATES_YOU,
                    json.encode(prefMotivatesYouMostList));
              } else if (currentPageIndex == 4) {
                Preference.shared.setString(
                    Constant.SELECTED_HOW_MANY_PUSH_UPS, prefHowManyPushUps!);
              } else if (currentPageIndex == 5) {
                Preference.shared.setString(
                    Constant.SELECTED_ACTIVITY_LEVEL, prefActivityLevel!);
              } else if (currentPageIndex == 8) {
                Utils.saveReminder(reminderList: reminderList);
                Preference.shared
                    .setBool(Constant.PREF_INTRODUCTION_FINISH, true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseListScreen(
                              fromPage: Constant.PAGE_DISCOVER,
                              planName: randomPlanData!.planName,
                              discoverPlanTable: randomPlanData,
                              isFromOnboarding: true,
                            )));
              }
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 60.0, right: 60, bottom: (isPlanReady!) ? 0.0 : 15.0),
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
              child: Center(
                child: Text(
                  (currentPageIndex == 8 && isPlanReady!)
                      ? Languages.of(context)!.txtStartNow.toUpperCase()
                      : Languages.of(context)!.txtNext.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colur.white),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isPlanReady!,
          child: InkWell(
            onTap: () {
              Utils.saveReminder(reminderList: reminderList);
              Preference.shared
                  .setBool(Constant.PREF_INTRODUCTION_FINISH, true);
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
