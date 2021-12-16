import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WeeklyDayData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/videoAnimation/video_animation_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';

class PauseScreen extends StatefulWidget {
  final List<WorkoutDetail>? workoutDetailList;
  final List<ExerciseListData>? exerciseListDataList;
  final String? fromPage;
  final List<DiscoverSingleExerciseData>? discoverSingleExerciseDataList;
  final int? index;
  final bool? isForQuit;
  final String? dayName;
  final String? weekName;
  final String? planName;
  final HomePlanTable? homePlanTable;
  final DiscoverPlanTable? discoverPlanTable;
  final WeeklyDayData? weeklyDayData;
  final bool? isSubPlan;
  final bool? isFromOnboarding;

  PauseScreen({
    this.workoutDetailList,
    this.fromPage,
    this.exerciseListDataList,
    this.discoverSingleExerciseDataList,
    this.index,
    this.isForQuit,
    this.planName = "",
    this.dayName = "",
    this.weekName = "",
    this.homePlanTable,
    this.isSubPlan=false,
    this.discoverPlanTable,
    this.weeklyDayData,
    this.isFromOnboarding
  });

  @override
  _PauseScreenState createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen>
    with TickerProviderStateMixin
    implements TopBarClickListener {
  Animation<int>? listLifeGuideAnimation;

  AnimationController? listLifeGuideController;

  int countOfImages = 0;

  @override
  void initState() {
    _setImageRotation(widget.index!);
    super.initState();
  }

  @override
  void dispose() {
    listLifeGuideController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return Future.value(true);
      },
      child: Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ), //
        ),
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                // Here we create one to set status bar color
                backgroundColor: Colur.theme,
                elevation: 0,
              )),
          backgroundColor: Colur.theme,
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  CommonTopBar(
                    "",
                    this,
                    isShowBack: true,
                    iconColor: Colur.white,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      children: [
                        _pauseHeader(context),
                        _restartBtn(context),
                        _quitBtn(context),
                        _resumeBtn(context),
                      ],
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

  _resumeBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, true);
      },
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            color: Colur.white,
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtResume.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.theme, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _quitBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseListScreen(
                  fromPage: widget.fromPage,
                  planName: widget.planName,
                  dayName: widget.dayName,
                  weekName: widget.weekName,
                  discoverPlanTable: widget.discoverPlanTable,
                  homePlanTable: widget.homePlanTable,
                  weeklyDayData: widget.weeklyDayData,
                  isSubPlan: widget.isSubPlan,
                  isFromOnboarding: widget.isFromOnboarding
                )),
            (route) => false);
        /*Navigator.pop(context, false);
        Navigator.pop(context);
        Navigator.pop(context);*/
      },
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtQuit.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.white, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _restartBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, false);
      },
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(top: 30, left: 15),
        decoration: BoxDecoration(
            border: Border.all(color: Colur.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          Languages.of(context)!.txtRestartThisExercise.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colur.white, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  _pauseHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isForQuit!
                    ? Languages.of(context)!.txtQuit
                    : Languages.of(context)!.txtPause,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colur.white,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoAnimationScreen(
                                fromPage: widget.fromPage,
                                workoutDetailList: widget.workoutDetailList,
                                index: widget.index,
                                exerciseListDataList:
                                    widget.exerciseListDataList,
                                discoverSingleExerciseDataList:
                                    widget.discoverSingleExerciseDataList,
                              )));
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RichText(
                    text: TextSpan(
                        text: _getExerciseNameFromList(),
                        style: TextStyle(
                            color: Colur.white.withOpacity(0.5),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                        children: [
                          WidgetSpan(
                              child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.help,
                              size: 20.0,
                              color: Colur.white.withOpacity(0.5),
                            ),
                          )),
                        ]),
                  ),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: (listLifeGuideAnimation != null)
                ? Container(
                    color: Colur.theme_trans,
                    width: 100.0,
                    height: 100.0,
                    child: AnimatedBuilder(
                      animation: listLifeGuideAnimation!,
                      builder: (BuildContext context, Widget? child) {
                        String frame = listLifeGuideAnimation!.value.toString();
                        return new Image.asset(
                          'assets/${_getExercisePathFromList()}/$frame${Constant.EXERCISE_EXTENSION}',
                          gaplessPlayback: true,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  )
                : Container(
                    color: Colur.theme_trans,
                    width: 100.0,
                    height: 100.0,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.pop(context, true);
    }
  }

  /*bool _timeTypeCheck() {
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList![widget.index!].timeType!
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList![widget.index!].timeType!
        : widget.discoverSingleExerciseDataList![widget.index!].exUnit!) ==
        ((widget.fromPage != Constant.PAGE_DISCOVER) ? "time" : "s");
  }

  String _getExerciseTimeFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList![widget.index!].time!
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList![widget.index!].Time_beginner
        : widget.discoverSingleExerciseDataList![widget.index!].exTime).toString();
  }

  int _getLengthFromList(){
    return ((widget.fromPage == Constant.PAGE_HOME)
        ? widget.exerciseListDataList!.length
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
        ? widget.workoutDetailList!.length
        : widget.discoverSingleExerciseDataList!.length);
  }*/

  String _getExerciseNameFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseListDataList![widget.index!].title!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.workoutDetailList![widget.index!].title
                : widget.discoverSingleExerciseDataList![widget.index!].exName)
        .toString();
  }

  String _getExercisePathFromList() {
    return ((widget.fromPage == Constant.PAGE_HOME)
            ? widget.exerciseListDataList![widget.index!].image!
            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                ? widget.workoutDetailList![widget.index!].image
                : widget.discoverSingleExerciseDataList![widget.index!].exPath)
        .toString();
  }

  _setImageRotation(int pos) async {
    await _getImageFromAssets(pos);

    int duration = 0;
    if (countOfImages > 2 && countOfImages <= 4) {
      duration = 3000;
    } else if (countOfImages > 4 && countOfImages <= 6) {
      duration = 4500;
    } else if (countOfImages > 6 && countOfImages <= 8) {
      duration = 6000;
    } else if (countOfImages > 8 && countOfImages <= 10) {
      duration = 8500;
    } else if (countOfImages > 10 && countOfImages <= 12) {
      duration = 9000;
    } else if (countOfImages > 12 && countOfImages <= 14) {
      duration = 14000;
    } else {
      duration = 1500;
    }

    listLifeGuideController = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    listLifeGuideAnimation = new IntTween(begin: 1, end: countOfImages)
        .animate(listLifeGuideController!);
    setState(() {});
  }

  _getImageFromAssets(int index) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
            key.contains(_getExercisePathFromList().toString() + "/"))
        .toList();

    countOfImages = imagePaths.length;
  }
}
