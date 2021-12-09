import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/dialogs/exercise_dialog.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WeeklyDayData.dart';
import 'package:homeworkout_flutter/database/model/WorkoutDetailData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/workout/workout_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseListScreen extends StatefulWidget {
  HomePlanTable? homePlanTable;
  String? fromPage;
  DiscoverPlanTable? discoverPlanTable;
  WeeklyDayData? weeklyDayData;
  String? dayName = "";
  String? weekName = "";
  String? planName = "";

  ExerciseListScreen(
      {this.homePlanTable,
      required this.fromPage,
      this.discoverPlanTable,
      this.weeklyDayData,
      this.dayName,
      this.weekName,
      this.planName});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen>
    with TickerProviderStateMixin {
  ScrollController? _scrollController;
  List<ExerciseListData> exerciseDataList = [];
  List<DiscoverSingleExerciseData> discoverSingleExerciseList = [];
  List<WorkoutDetail> workoutDetailList = [];
  bool lastStatus = true;
  int? totalSeconds = 0;
  int? totalMinutes = 0;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    for (int j = 0; j < listLifeGuideController.length; j++) {
      listLifeGuideController[j].dispose();
    }
    super.dispose();
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (100 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    _getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle:
              isShrink ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ), //
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 0,
                  expandedHeight: 150.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colur.bg_white,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  title: isShrink
                      ? Text(
                          (widget.fromPage == Constant.PAGE_HOME)
                              ? widget.homePlanTable!.catName!.toUpperCase()
                              : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                                  ? Languages.of(context)!.txtDay +
                                      " " +
                                      widget.dayName
                                          .toString()
                                          .replaceAll("0", "")
                                  : widget.discoverPlanTable!.planName!
                                      .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colur.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        )
                      : Container(),
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.arrow_back_sharp,
                        color: isShrink ? Colur.black : Colur.white,
                        size: 25.0,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 0.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              // 'assets/images/abs_advanced.webp',
                              _getTopImageNameFromList(),
                            ),
                            fit: BoxFit.cover),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: (widget.fromPage !=
                                        Constant.PAGE_DAYS_STATUS)
                                    ? 30
                                    : 0),
                            child: Text(
                              (widget.fromPage == Constant.PAGE_HOME)
                                  ? widget.homePlanTable!.catName!.toUpperCase()
                                  : (widget.fromPage ==
                                          Constant.PAGE_DAYS_STATUS)
                                      ? Languages.of(context)!.txtDay +
                                          " " +
                                          widget.dayName
                                              .toString()
                                              .replaceAll("0", "")
                                      : widget.discoverPlanTable!.planName!
                                          .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colur.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                widget.fromPage == Constant.PAGE_DAYS_STATUS,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                                    ? widget.planName.toString().toUpperCase()
                                    : "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colur.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              color: Colur.bg_white,
              margin: const EdgeInsets.only(top: 5.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Visibility(
                          visible: (widget.fromPage == Constant.PAGE_DISCOVER &&
                              widget.discoverPlanTable!.introduction != null),
                          child: _instructionWidget(),
                        ),
                        _timesAndWorkoutsTitle(),
                        _divider(),
                        (widget.fromPage == Constant.PAGE_HOME ||
                                widget.fromPage == Constant.PAGE_DAYS_STATUS)
                            ? _widgetExerciseListWithEdit()
                            : _widgetExerciseListWithOutEdit(),
                      ],
                    ),
                  ),
                  _divider(),
                  _startButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _instructionWidget() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colur.transparent,
        unselectedWidgetColor: Colur.txt_gray,
      ),
      child: ExpansionTile(
        iconColor: Colur.txt_gray,
        collapsedIconColor: Colur.txt_gray,
        title: Text(
          Languages.of(context)!.txtInstruction,
          textAlign: TextAlign.left,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w700, color: Colur.black),
        ),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Text(
                (widget.fromPage == Constant.PAGE_DISCOVER)?setInstructionText():"",
              style: TextStyle(
                color: Colur.txt_gray,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(
            height: 15,
            thickness: 1,
            color: Colur.gray_light,
          )
        ],
      ),
    );
  }

  String setInstructionText() {
    return (widget.discoverPlanTable!.introduction != "")
        ? widget.discoverPlanTable!.introduction.toString()
        : "";
  }

  _timesAndWorkoutsTitle() {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
      child: Row(
        children: [
          Container(
            color: Colur.theme,
            height: 12,
            width: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                _getTotalMinAndWorkoutTime(),
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colur.txtBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getTotalMinAndWorkoutTime() {
    return (widget.fromPage == Constant.PAGE_HOME)
        ? totalMinutes.toString() +
            " " +
            Languages.of(context)!.txtMin.toLowerCase() +
            " - " +
            exerciseDataList.length.toString() +
            " " +
            Languages.of(context)!.txtWorkouts.toLowerCase()
        : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
            ? totalMinutes.toString() +
                " " +
                Languages.of(context)!.txtMin.toLowerCase() +
                " - " +
                workoutDetailList.length.toString() +
                " " +
                Languages.of(context)!.txtWorkouts.toLowerCase()
            : totalMinutes.toString() +
                " " +
                Languages.of(context)!.txtMin.toLowerCase() +
                " - " +
                discoverSingleExerciseList.length.toString() +
                " " +
                Languages.of(context)!.txtWorkouts.toLowerCase();
  }

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _widgetExerciseListWithEdit() {
    var totalLength = 0;
    if (widget.fromPage == Constant.PAGE_HOME) {
      totalLength = exerciseDataList.length;
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      totalLength = workoutDetailList.length;
    }
    return Expanded(
      child: Theme(
        data: ThemeData(
          canvasColor: Colur.transparent,
          shadowColor: Colur.transparent,
        ),
        child: ReorderableListView(
          children: <Widget>[
            for (int index = 0; index < totalLength; index++)
              ListTile(
                key: Key('$index'),
                title: _listOfExerciseWithEdit(index),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              _reorderExercise(newIndex, oldIndex);
            });
          },
        ),
      ),
    );
  }

  _reorderExercise(int newIndex, int oldIndex) async {
    if (widget.fromPage == Constant.PAGE_HOME) {
      final ExerciseListData exerciseListData =
          exerciseDataList.removeAt(oldIndex);
      exerciseDataList.insert(newIndex, exerciseListData);
      for (int i = 0; i < exerciseDataList.length; i++) {
        await DataBaseHelper().reorderExercise(exerciseDataList[i].workoutId,
            i + 1, widget.homePlanTable!.catTableName.toString());
      }
    } else {
      WorkoutDetail workoutDetail = workoutDetailList.removeAt(oldIndex);
      workoutDetailList.insert(newIndex, workoutDetail);
      var tableName = "";
      if (widget.planName!.toUpperCase() ==
          Constant.Full_body_small.toUpperCase()) {
        tableName = Constant.tbl_full_body_workouts_list;
      } else if (widget.planName!.toUpperCase() ==
          Constant.Lower_body_small.toUpperCase()) {
        tableName = Constant.tbl_lower_body_list;
      }
      for (int i = 0; i < workoutDetailList.length; i++) {
        await DataBaseHelper()
            .reorderExercise(workoutDetailList[i].workoutId, i + 1, tableName);
      }
    }
  }

  _listOfExerciseWithEdit(int index) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: true,
          barrierColor: Colur.transparent_black_50,
          builder: (BuildContext context) {
            return ExerciseDialog(
              fromPage: widget.fromPage,
              workoutDetailList: workoutDetailList,
              discoverSingleExerciseDataList: discoverSingleExerciseList,
              exerciseListDataList: exerciseDataList,
              index: index,
            );
          },
        );
      },
      child: Container(
        // color: Colur.black,
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Icon(Icons.menu_rounded, color: Colur.iconGrey),
                ),
                /*Container(
                  height: 90.0,
                  width: 100.0,
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/arm_advanced.webp',
                    gaplessPlayback: true,
                    fit: BoxFit.cover,
                  ),
                ),*/

                (listOfImagesCount.isEmpty)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        margin: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/arm_advanced.webp',
                          gaplessPlayback: true,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        child: AnimatedBuilder(
                          animation: listLifeGuideAnimation[index],
                          builder: (BuildContext context, Widget? child) {
                            String frame =
                                listLifeGuideAnimation[index].value.toString();
                            return new Image.asset(
                              'assets/${_getImagePathFromList(index)}/$frame${Constant.EXERCISE_EXTENSION}',
                              gaplessPlayback: true,
                            );
                          },
                        ),
                      ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (widget.fromPage == Constant.PAGE_HOME)
                              ? exerciseDataList[index].title.toString()
                              : workoutDetailList[index].title.toString(),
                          style: TextStyle(
                              color: Colur.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (widget.fromPage == Constant.PAGE_HOME)
                                      ? ((exerciseDataList[index].timeType ==
                                              "step")
                                          ? "x${exerciseDataList[index].time.toString()}"
                                          : Utils.secondToMMSSFormat(int.parse(
                                              exerciseDataList[index]
                                                  .time
                                                  .toString())))
                                      : ((workoutDetailList[index].timeType ==
                                              "step")
                                          ? "x${workoutDetailList[index].Time_beginner.toString()}"
                                          : Utils.secondToMMSSFormat(int.parse(
                                              workoutDetailList[index]
                                                  .Time_beginner
                                                  .toString()))),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colur.txt_gray),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 35.0),
              child: _divider(),
            )
          ],
        ),
      ),
    );
  }

  _widgetExerciseListWithOutEdit() {
    return Expanded(
      child: Container(
        child: ListView.builder(
          shrinkWrap: false,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _listOfExerciseWithOutEdit(index);
          },
          itemCount: discoverSingleExerciseList.length,
        ),
      ),
    );
  }

  _listOfExerciseWithOutEdit(int index) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          useSafeArea: true,
          barrierColor: Colur.transparent_black_50,
          builder: (BuildContext context) {
            return ExerciseDialog(
              fromPage: widget.fromPage,
              workoutDetailList: workoutDetailList,
              discoverSingleExerciseDataList: discoverSingleExerciseList,
              exerciseListDataList: exerciseDataList,
              index: index,
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                (listOfImagesCount.isEmpty)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        margin: const EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/arm_advanced.webp',
                          gaplessPlayback: true,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        child: AnimatedBuilder(
                          animation: listLifeGuideAnimation[index],
                          builder: (BuildContext context, Widget? child) {
                            String frame =
                                listLifeGuideAnimation[index].value.toString();
                            return new Image.asset(
                              'assets/${_getImagePathFromList(index)}/$frame${Constant.EXERCISE_EXTENSION}',
                              gaplessPlayback: true,
                            );
                          },
                        ),
                      ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discoverSingleExerciseList[index].exName.toString(),
                          style: TextStyle(
                              color: Colur.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (discoverSingleExerciseList[index].exUnit ==
                                          "s")
                                      ? Utils.secondToMMSSFormat(int.parse(
                                          discoverSingleExerciseList[index]
                                              .ExTime
                                              .toString()))
                                      : "x" +
                                          discoverSingleExerciseList[index]
                                              .ExTime
                                              .toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colur.txt_gray),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 35.0),
              child: _divider(),
            )
          ],
        ),
      ),
    );
  }

  _startButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        gradient: LinearGradient(
          colors: [
            Colur.blueGradientButton1,
            Colur.blueGradientButton2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: TextButton(
        child: Text(
          Languages.of(context)!.txtStart.toUpperCase(),
          style: TextStyle(
            color: Colur.white,
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
        onPressed: () {
          var tableName = "";
          var planName = "";
          var planId = "";
          if (widget.fromPage == Constant.PAGE_HOME) {
            tableName = widget.homePlanTable!.catTableName.toString();
          } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS &&
              widget.planName != "") {
            if (widget.planName == Constant.Full_body_small) {
              tableName = Constant.tbl_full_body_workouts_list;
            } else if (widget.planName == Constant.Lower_body_small) {
              tableName = Constant.tbl_lower_body_list;
            }
          } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
            planName = widget.discoverPlanTable!.planName.toString();
            planId = widget.discoverPlanTable!.planId.toString();
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkoutScreen(
                        fromPage: widget.fromPage,
                        dayStatusDetailList: workoutDetailList,
                        exerciseDataList: exerciseDataList,
                        tableName: tableName,
                        dayName: widget.dayName,
                        weekName: widget.weekName,
                        discoverSingleExerciseData: discoverSingleExerciseList,
                        planName: widget.planName,
                        planId: planId,
                        totalMin: totalMinutes,
                      )));
        },
      ),
    );
  }

  _getDataFromDatabase() async {
    _getAllExerciseList();
    totalMin();
  }

  String _getTopImageNameFromList() {
    var imageName = "";
    var gender = Preference.shared.getString(Constant.SELECTED_GENDER) ??
        Constant.GENDER_MEN;
    if (widget.fromPage == Constant.PAGE_HOME) {
      imageName = widget.homePlanTable!.catImage.toString() +
          "_" +
          gender.toString() +
          ".webp";
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      if (widget.planName!.toUpperCase() ==
          Constant.Full_body_small.toUpperCase()) {
        imageName = "assets/exerciseImage/other/full_body_$gender.webp";
      } else if (widget.planName!.toUpperCase() ==
          Constant.Lower_body_small.toUpperCase()) {
        imageName = "assets/exerciseImage/other/lower_body_$gender.webp";
      }
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      imageName = widget.discoverPlanTable!.planImage.toString();
    }
    return imageName;
  }

  totalMin() async {
    if (widget.fromPage == Constant.PAGE_HOME) {
      totalSeconds = await DataBaseHelper().getTotalWorkoutMinutesForHome(
          widget.homePlanTable!.catTableName.toString());
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      var tableName = "";
      if (widget.planName == Constant.Full_body_small) {
        tableName = Constant.tbl_full_body_workouts_list;
      } else {
        tableName = Constant.tbl_lower_body_list;
      }
      totalSeconds = await DataBaseHelper().getTotalWorkoutMinutesForDaysStatus(
          widget.dayName.toString(), widget.weekName.toString(), tableName);
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      totalSeconds = await DataBaseHelper().getTotalWorkoutMinutesForDiscover(
          widget.discoverPlanTable!.planId.toString());
    }
    totalMinutes = Duration(seconds: totalSeconds!).inMinutes;
  }

  _getAllExerciseList() async {
    if (widget.fromPage == Constant.PAGE_HOME) {
      exerciseDataList = await DataBaseHelper()
          .getExercisePlanNameWise(widget.homePlanTable!.catTableName!);
      exerciseDataList.sort((a, b) => a.sort!.compareTo(b.sort!));
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      discoverSingleExerciseList = await DataBaseHelper()
          .getDiscoverExercisePlanIdWise(
              widget.discoverPlanTable!.planId.toString());
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      var tableName = "";
      if (widget.planName == Constant.Full_body_small) {
        tableName = Constant.tbl_full_body_workouts_list;
      } else {
        tableName = Constant.tbl_lower_body_list;
      }
      workoutDetailList = await DataBaseHelper().getWeekDayExerciseData(
          widget.dayName.toString(), widget.weekName.toString(), tableName);
      workoutDetailList.sort((a, b) => a.sort!.compareTo(b.sort!));
    }
    _imageCount();
    setState(() {});
  }

  List<Animation<int>> listLifeGuideAnimation = [];
  List<AnimationController> listLifeGuideController = [];
  List<int> listOfImagesCount = [];

  _imageCount() async {
    for (int i = 0; i < _getTotalLength()!; i++) {
      await _getImageFromAssets(i);
      int duration = 0;
      if (listOfImagesCount[i] > 2 && listOfImagesCount[i] <= 4) {
        duration = 3000;
      } else if (listOfImagesCount[i] > 4 && listOfImagesCount[i] <= 6) {
        duration = 4500;
      } else if (listOfImagesCount[i] > 6 && listOfImagesCount[i] <= 8) {
        duration = 6000;
      } else if (listOfImagesCount[i] > 8 && listOfImagesCount[i] <= 10) {
        duration = 7500;
      } else if (listOfImagesCount[i] > 10 && listOfImagesCount[i] <= 12) {
        duration = 9000;
      } else if (listOfImagesCount[i] > 12 && listOfImagesCount[i] <= 14) {
        duration = 10500;
      } else {
        duration = 1500;
      }

      listLifeGuideController.add(new AnimationController(
          vsync: this, duration: Duration(milliseconds: duration))
        ..repeat());

      listLifeGuideAnimation.add(
          new IntTween(begin: 1, end: listOfImagesCount[i])
              .animate(listLifeGuideController[i]));
    }
  }

  int? _getTotalLength() {
    var totalLength = 0;
    if (widget.fromPage == Constant.PAGE_HOME) {
      totalLength = exerciseDataList.length;
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      totalLength = workoutDetailList.length;
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      totalLength = discoverSingleExerciseList.length;
    }
    return totalLength;
  }

  String? _getImagePathFromList(int index) {
    var exPath = "";
    if (widget.fromPage == Constant.PAGE_HOME) {
      exPath = exerciseDataList[index].image.toString();
    } else if (widget.fromPage == Constant.PAGE_DAYS_STATUS) {
      exPath = workoutDetailList[index].image.toString();
    } else if (widget.fromPage == Constant.PAGE_DISCOVER) {
      exPath = discoverSingleExerciseList[index].exPath.toString();
    }
    return exPath;
  }

  _getImageFromAssets(int index) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where(
            (String key) => key.contains(_getImagePathFromList(index)! + "/"))
        .toList();

    listOfImagesCount.add(imagePaths.length);
  }
}
