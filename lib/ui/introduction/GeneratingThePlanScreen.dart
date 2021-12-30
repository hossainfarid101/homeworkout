import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/reminder_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GeneratingThePlanScreen extends StatefulWidget {
  final bool? isPlanReady;
  final Function onValueChanged;
  final Function onValueChangeRandomPlanData;
  final List<ReminderTable>? onReminderList;

  GeneratingThePlanScreen(this.isPlanReady, this.onValueChanged,
      this.onValueChangeRandomPlanData, this.onReminderList);

  @override
  _GeneratingThePlanScreenState createState() =>
      _GeneratingThePlanScreenState();
}

class _GeneratingThePlanScreenState extends State<GeneratingThePlanScreen>
    with TickerProviderStateMixin {
  Timer? periodicTimer;
  double? percent = 0.0;
  DiscoverPlanTable? randomPlanData;

  @override
  void initState() {
    _getRandomPlanData();
    periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (percent! < 1.0) {
            percent = (timer.tick) / 5;
          }
          if (timer.tick == 6) {
            widget.onValueChanged(true);
            widget.onValueChangeRandomPlanData(randomPlanData);
          }
        });
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    periodicTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPlanReady == false
        ? Center(
            child: CircularPercentIndicator(
              backgroundColor: Colur.track_gray,
              radius: 245,
              linearGradient: LinearGradient(
                  colors: [Colur.blueGradient1, Colur.blueGradient2]),
              lineWidth: 12,
              backgroundWidth: 8,
              percent: percent!,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animateFromLastPercent: true,
              center: Text(
                (percent! * 100).toStringAsFixed(0) + " %",
                style: TextStyle(
                    fontSize: 42,
                    color: Colur.track_gray,
                    fontWeight: FontWeight.w600),
              ),
              footer: Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  Languages.of(context)!.txtSelectingTargetedWorkoutsForYou,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colur.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colur.grey.withOpacity(0.1),
                ),
                child: Image.asset(
                  'assets/images/avatar_male.png',
                  fit: BoxFit.fill,
                  scale: 2,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                Languages.of(context)!.txtYourPlanIsReady.toUpperCase(),
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colur.black),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  Languages.of(context)!.txtWeHaveSelectedThisPlan,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colur.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              _discoverCard()
            ],
          ));
  }

  _discoverCard() {
    return InkWell(
      onTap: () {
        Utils.saveReminder(reminderList: widget.onReminderList);
        Preference.shared.setBool(Constant.PREF_INTRODUCTION_FINISH, true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseListScreen(
                    fromPage: Constant.PAGE_DISCOVER,
                    planName: randomPlanData!.planName,
                    discoverPlanTable: randomPlanData,
                    isFromOnboarding: true)));
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 195,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(randomPlanData!.planImage.toString()),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Container(
              color: Colur.transparent_black_50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 15.0, bottom: 0.0, left: 15.0, right: 15.0),
                    child: Text(
                      (randomPlanData != null) ? randomPlanData!.planName! : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colur.white),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        top: 12.0, bottom: 25.0, left: 15.0, right: 15.0),
                    child: AutoSizeText(
                      (randomPlanData != null &&
                              randomPlanData!.shortDes! != "")
                          ? randomPlanData!.shortDes!
                          : randomPlanData!.introduction!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colur.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getRandomPlanData() async {
    var lastDate =
        Preference.shared.getString(Constant.PREF_RANDOM_DISCOVER_PLAN_DATE) ??
            "";
    var currDate = Utils.getCurrentDate();
    var strPlan =
        Preference.shared.getString(Constant.PREF_RANDOM_DISCOVER_PLAN) ?? "";
    Debug.printLog("strPlan=>>>  " + strPlan.toString());
    if (lastDate.isNotEmpty && currDate == lastDate && strPlan.isNotEmpty) {
      randomPlanData = DiscoverPlanTable.fromJson(jsonDecode(strPlan));
    } else {
      randomPlanData = await DataBaseHelper().getRandomDiscoverPlan();
      Preference.shared
          .setString(Constant.PREF_RANDOM_DISCOVER_PLAN_DATE, currDate);
      Preference.shared.setString(Constant.PREF_RANDOM_DISCOVER_PLAN,
          jsonEncode(randomPlanData!.toJson()));
    }

    setState(() {});
  }
}
