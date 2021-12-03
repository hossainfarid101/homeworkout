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
import 'package:homeworkout_flutter/utils/utils.dart';

class ExerciseListScreen extends StatefulWidget {

  HomePlanTable? homePlanTable;
  String? fromPage;
  DiscoverPlanTable? discoverPlanTable;
  WeeklyDayData? weeklyDayData;
  String? dayName = "";
  String? weekName = "";
  String? planName = "";


  ExerciseListScreen({this.homePlanTable,required this.fromPage,this.discoverPlanTable,this.weeklyDayData,this.dayName,
  this.weekName,this.planName});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  ScrollController? _scrollController;
  List<ExerciseListData> exerciseDataList = [];
  List<DiscoverSingleExerciseData> discoverSingleExerciseList = [];
  List<WorkoutDetail> workoutDetailList = [];
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
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
  void dispose() {
    _scrollController!.removeListener(_scrollListener);
    super.dispose();
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
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                backgroundColor: Colur.white,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: isShrink
                    ? Text(
                  (widget.fromPage == Constant.PAGE_HOME)
                            ? widget.homePlanTable!.catName!.toUpperCase()
                            : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                                ? Languages.of(context)!.txtDay+" "+widget.dayName.toString().replaceAll("0", "")
                                : widget.discoverPlanTable!.planName!.toUpperCase(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/abs_advanced.webp',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical:
                                  (widget.fromPage != Constant.PAGE_DAYS_STATUS)
                                      ? 30
                                      : 0),
                          child: Text(
                            (widget.fromPage == Constant.PAGE_HOME)
                                ? widget.homePlanTable!.catName!.toUpperCase()
                                : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                                ? Languages.of(context)!.txtDay+" "+widget.dayName.toString().replaceAll("0", "")
                                : widget.discoverPlanTable!.planName!.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colur.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.fromPage == Constant.PAGE_DAYS_STATUS,
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
            color: Colur.white,
            margin: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _timesAndWorkoutsTitle(),
                      _divider(),

                      /*(widget.fromPage == Constant.PAGE_HOME)
                          ? _widgetExerciseListWithEdit()
                          : __widgetExerciseListWithOutEdit(),*/

                      (widget.fromPage == Constant.PAGE_HOME || widget.fromPage == Constant.PAGE_DAYS_STATUS)
                          ? _widgetExerciseListWithEdit()
                          : __widgetExerciseListWithOutEdit(),
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
    );
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
                (widget.fromPage == Constant.PAGE_HOME)
                    ? exerciseDataList.length.toString() +
                        " " +
                        Languages.of(context)!.txtWorkouts.toLowerCase()
                    : (widget.fromPage == Constant.PAGE_DAYS_STATUS)
                        ? workoutDetailList.length.toString() +
                            " " +
                            Languages.of(context)!.txtWorkouts.toLowerCase()
                        : discoverSingleExerciseList.length.toString() +
                            " " +
                            Languages.of(context)!.txtWorkouts.toLowerCase(),
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

  _divider() {
    return Divider(
      height: 1.0,
      color: Colur.grayDivider,
    );
  }

  _widgetExerciseListWithEdit() {
    var totalLength = 0;
    if(widget.fromPage == Constant.PAGE_HOME){
      totalLength = exerciseDataList.length;
    }else if(widget.fromPage == Constant.PAGE_DAYS_STATUS){
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
            setState(()  {
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

  _reorderExercise(int newIndex,int oldIndex) async {
    if(widget.fromPage == Constant.PAGE_HOME) {
      final ExerciseListData exerciseListData = exerciseDataList.removeAt(oldIndex);
      exerciseDataList.insert(newIndex, exerciseListData);
      for(int i=0;i<exerciseDataList.length;i++){
        await DataBaseHelper().reorderExercise(exerciseDataList[i].workoutId,
            i + 1, widget.homePlanTable!.catTableName.toString());
      }
    }else{
      WorkoutDetail workoutDetail = workoutDetailList.removeAt(oldIndex);
      workoutDetailList.insert(newIndex, workoutDetail);
      var tableName = "";
      if(widget.planName == Constant.Full_body_small){
        tableName = Constant.tbl_full_body_workouts_list;
      }else if(widget.planName == Constant.Lower_body_small){
        tableName = Constant.tbl_lower_body_list;
      }
      for(int i=0;i<workoutDetailList.length;i++){
        await DataBaseHelper().reorderExercise(workoutDetailList[i].workoutId,
            i + 1,tableName);
      }
    }
  }
  _listOfExerciseWithEdit(int index) {
    return InkWell(
      onTap: (){

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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Icon(Icons.menu_rounded, color: Colur.iconGrey),
              ),
              Container(
                height: 90.0,
                width: 100.0,
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/arm_advanced.webp',
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
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
                                        : Utils.secondToMMSSFormat(int.parse(exerciseDataList[index].time.toString())))
                                    : ((workoutDetailList[index].timeType ==
                                            "step")
                                        ? "x${workoutDetailList[index].Time_beginner.toString()}"
                                        : Utils.secondToMMSSFormat(int.parse(workoutDetailList[index]
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
    );
  }

  __widgetExerciseListWithOutEdit(){
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
      onTap: (){
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 90.0,
                width: 100.0,
                margin: const EdgeInsets.only(top: 10,left: 30,right: 10,bottom: 10),
                child: Image.asset(
                  'assets/images/arm_advanced.webp',
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
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
                                (discoverSingleExerciseList[index].exUnit == "s")
                                    ? Utils.secondToMMSSFormat(int.parse(discoverSingleExerciseList[index].ExTime.toString()))
                                    : "x" + discoverSingleExerciseList[index].ExTime.toString(),
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
          if(widget.fromPage == Constant.PAGE_HOME){
            tableName = widget.homePlanTable!.catTableName.toString();
          }else if(widget.fromPage == Constant.PAGE_HOME && widget.planName != ""){
            if(widget.planName == Constant.Full_body_small){
              tableName = Constant.tbl_full_body_workouts_list;
            }else if(widget.planName == Constant.Lower_body_small){
              tableName = Constant.tbl_lower_body_list;
            }
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
                      )));
        },
      ),
    );
  }

  _getDataFromDatabase(){
    _getAllExerciseList();
  }

  _getAllExerciseList() async{
    if(widget.fromPage == Constant.PAGE_HOME) {
      exerciseDataList = await DataBaseHelper().getExercisePlanNameWise(widget.homePlanTable!.catTableName!);
      exerciseDataList.sort((a, b) => a.sort!.compareTo(b.sort!));

    }else if(widget.fromPage == Constant.PAGE_DISCOVER){
      discoverSingleExerciseList = await DataBaseHelper().getDiscoverExercisePlanIdWise(widget.discoverPlanTable!.planId.toString());

    }else if(widget.fromPage == Constant.PAGE_DAYS_STATUS){
      var tableName = "";
      if(widget.planName == Constant.Full_body_small){
        tableName = Constant.tbl_full_body_workouts_list;
      }else{
        tableName = Constant.tbl_lower_body_list;
      }
      workoutDetailList = await DataBaseHelper().getWeekDayExerciseData(
          widget.dayName.toString(), widget.weekName.toString(),tableName);
      workoutDetailList.sort((a, b) => a.sort!.compareTo(b.sort!));
    }
    setState(() {});
  }
}
