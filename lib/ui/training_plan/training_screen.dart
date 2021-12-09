import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/tables/fullbody_workout_table.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/discover/DiscoverScreen.dart';
import 'package:homeworkout_flutter/ui/exerciseDays/exercise_days_status_screen.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/quarantineathome/QuarantineAtHomeScreen.dart';
import 'package:homeworkout_flutter/ui/setWeeklyGoal/set_weekly_goal_screen.dart';
import 'package:homeworkout_flutter/ui/workoutHistory/workout_history_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key}) : super(key: key);

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}


class _TrainingScreenState extends State<TrainingScreen>
    implements TopBarClickListener {

  ScrollController? _scrollController;

  bool lastStatus = true;

  String? totalWeekTrainingDays;
  List<HomePlanTable> allPlanDataList = [];
  int? totalQuarantineWorkout = 0;
  int? totalWorkout = 0;
  double? totalKcal = 0.0;
  int? totalMin = 0;
  List<bool> isAvailableHistory = [];
  int dayInRow = 0;
  String progress = "";
  int? intProgress = 0;
  String leftDays = "";
  String? selectedTrainingDay = "";
  int? selectedFirstDayOfWeek = 0;
  int? totalDayOfWeekGoal = 0;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    Preference.shared.setInt(Preference.DRAWER_INDEX, 0);
    selectedFirstDayOfWeek = Preference.shared.getInt(Preference.SELECTED_FIRST_DAY_OF_WEEK)??0;
    selectedTrainingDay = Preference.shared.getString(Preference.SELECTED_TRAINING_DAY)??"";
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    _getDataFromDatabase();
    _getPreference();
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
          systemOverlayStyle: isShrink ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        ),//
      ),
      child: Scaffold(
        drawer: DrawerMenu(),
        backgroundColor: Colur.iconGreyBg,
        body: SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  elevation: 2,
                  expandedHeight: 280.0,
                  floating: false,
                  pinned: true,
                  titleSpacing:-5,
                  leading: InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: isShrink ? Colur.black : Colur.white,
                      )),
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(Languages.of(context)!.txtHomeWorkout.toUpperCase(),
                        style: TextStyle(
                          color: isShrink ? Colur.black : Colur.white,
                          fontSize: 16.0,
                        )),
                  ),
                  backgroundColor: Colors.white,
                  centerTitle: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/main_bg.webp"),
                          fit: BoxFit.cover
                        )
                      ),
                      // color: Colur.theme,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 250,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 30),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkoutHistoryScreen()));
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                   Text((totalWorkout != 0) ? totalWorkout.toString() : "0",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colur.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(Languages.of(context)!.txtWorkout
                                                      .toUpperCase(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colur.white.withOpacity(0.6),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text((totalKcal != 0) ? totalKcal.toString() : "0",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colur.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(Languages.of(context)!.txtKcal
                                                      .toUpperCase(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colur.white.withOpacity(0.6),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(Utils.secondToMMSSFormat((totalMin != 0) ?totalMin!:0),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colur.white,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500)),
                                                  Text(Languages.of(context)!.txtDuration
                                                      .toUpperCase(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colur.white.withOpacity(0.6),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 70,
                                      color: Colur.iconGreyBg,
                                    ),
                                  ],
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 90.0, right: 20, left: 20,bottom: 10),
                                  decoration: const BoxDecoration(
                                    color: Colur.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colur.transparent_black_30,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          visible: (selectedTrainingDay == ""),
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                margin: const EdgeInsets.all(10),
                                                child: Text(
                                                    Languages.of(context)!.txtWeekGoal
                                                        .toUpperCase(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colur.txtBlack,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500)),
                                              ),
                                              Container(
                                                margin:
                                                const EdgeInsets.only(top: 10),
                                                child: Text(
                                                    Languages.of(context)!
                                                        .txtWeekGoalDesc,
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colur.grey,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SetWeeklyGoalScreen())).then((value) => _getPreference());
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(15),
                                                  decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colur.blueGradientButton1,
                                                            Colur.blueGradientButton2,
                                                          ],
                                                          begin: Alignment.centerLeft,
                                                          end: Alignment.centerRight,
                                                          stops: [0.0, 1.0],
                                                          tileMode: TileMode.clamp),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(30)),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 15, horizontal: 20),
                                                  child: Center(
                                                    child: Text(
                                                        Languages.of(context)!
                                                            .txtSetAGoal
                                                            .toUpperCase(),
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                            color: Colur.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight.w500)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Visibility(
                                          visible: (selectedTrainingDay != ""),
                                          child: Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SetWeeklyGoalScreen())).then((value) => _getPreference());
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.topLeft,
                                                        margin: const EdgeInsets.all(10),
                                                        child: Text(
                                                            Languages.of(context)!.txtWeekGoal
                                                                .toUpperCase(),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                color: Colur.txtBlack,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500)),
                                                      ),
                                                      Icon(Icons.edit_rounded,size: 15),
                                                      Expanded(
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            "${totalDayOfWeekGoal.toString()}/" +
                                                                totalWeekTrainingDays!,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 15.0,bottom: 10),
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return _itemOfWeekGoal(index);
                                                    },
                                                    itemCount: isAvailableHistory.length,
                                                    // itemCount: 7,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            controller: _scrollController,
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _widgetListOfPlan(),
                          _widgetDiscover(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _widgetListOfPlan() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: allPlanDataList.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        return itemPlan(index);
      },
    );
  }

  itemPlan(int index) {

    var gender = Preference.shared.getString(Constant.SELECTED_GENDER)??Constant.GENDER_MEN;
    Debug.printLog("allPlanDataList[index].catImage====>>  "+allPlanDataList[index].catImage.toString());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            // visible: (index == 0 || index == 2 || index == 3 || index == 8 || index == 13 || index == 18),
            visible: (allPlanDataList[index].catSubCategory == Constant.title)?true:false,
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 5,left: 5),
              child: Text(
                allPlanDataList[index].catName.toString().toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colur.black,
                ),
              ),
            ),
          ),
          Visibility(
              visible: (allPlanDataList[index].catSubCategory != Constant.title)?true:false,
              child: Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          // image: AssetImage('assets/exerciseImage/beginner/abs_beginner_men.webp'),
                          image: AssetImage((allPlanDataList[index].catImage! != Constant.title)
                              ?allPlanDataList[index].catImage!+"_$gender.webp"
                              :'assets/exerciseImage/beginner/abs_beginner_men.webp'),
                          fit: BoxFit.cover),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      color: Colur.transparent_black_50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: _isDayStatusPlan(index)?true:false ,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      ExerciseDaysStatusScreen(planName:allPlanDataList[index].catName ,)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Text(
                                              allPlanDataList[index].catName!.toUpperCase(),
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Colur.white),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15.0, vertical: 5),
                                            child: Text(
                                                Languages.of(context)!
                                                    .txt7X4Challenge,
                                                style: TextStyle(
                                                    color: Colur.white,
                                                    fontSize: 16.0)),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              FutureBuilder(
                                                future: _setLeftDayProgressDataByPlan(allPlanDataList[index].catTableName.toString()),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<dynamic> snapshot) {
                                                  if (snapshot.hasData) {
                                                    return
                                                      Container(
                                                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                                        child: Text(snapshot.data.toString(),
                                                            style: TextStyle(
                                                                color: Colur.white,
                                                                fontSize: 14.0)),
                                                      );
                                                  }else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              Expanded(
                                                child: FutureBuilder(
                                                  future: _setDayProgressPercentagePlan(allPlanDataList[index].catTableName.toString()),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<dynamic> snapshot) {
                                                    if (snapshot.hasData) {
                                                      return
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          margin:
                                                          const EdgeInsets.symmetric(horizontal: 15.0),
                                                          child: Text(snapshot.data.toString(),
                                                              style: TextStyle(
                                                                  color: Colur.white, fontSize: 14.0)),
                                                        );
                                                    }else {
                                                      return Container();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        FutureBuilder(
                                          future: _setDayProgressDataByPlan(allPlanDataList[index].catTableName.toString()),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapshot) {
                                            if (snapshot.hasData) {
                                              return
                                                Container(
                                                  margin: const EdgeInsets.only(right: 10,left: 10,top: 10,bottom: 20),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    child: LinearProgressIndicator(
                                                      value: (snapshot.data / 100).toDouble(),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colur.theme),
                                                      backgroundColor: Colur.transparent_50,
                                                      minHeight: 5,
                                                    ),
                                                  ),
                                                );
                                            }else {
                                              return Container();
                                            }
                                          },
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (allPlanDataList[index].catSubCategory == Constant.titleQuarantineAtHome &&
                                allPlanDataList[index].catSubCategory != Constant.txt_7_4_challenge)?true:false,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>QuarantineAtHomeScreen()));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Text(
                                              allPlanDataList[index].catName!.toUpperCase(),
                                              maxLines: 1,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  color: Colur.white),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                            child: Text( "$totalQuarantineWorkout " + Languages.of(context)!.txtWorkouts.toLowerCase(),
                                                style: TextStyle(color: Colur.white, fontSize: 16.0,fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30,
                                          color: Colur.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (allPlanDataList[index].catSubCategory != Constant.titleQuarantineAtHome &&
                                allPlanDataList[index].catSubCategory != Constant.txt_7_4_challenge)?true:false,
                            child: Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ExerciseListScreen(
                                                homePlanTable:
                                                    allPlanDataList[index],
                                                fromPage: Constant.PAGE_HOME,
                                                planName: allPlanDataList[index].catName,
                                              )));
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                                          child: Text(
                                            allPlanDataList[index].catName!.toUpperCase(),
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Colur.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.bolt_rounded, color: Colur.blue,size: 18,),
                                            Icon(Icons.bolt_rounded, color: Colur.grey_icon,size: 18,),
                                            Icon(Icons.bolt_rounded, color: Colur.grey_icon,size: 18,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  bool _isDayStatusPlan(int index){
    return (allPlanDataList[index].catSubCategory == Constant.txt_7_4_challenge &&
        allPlanDataList[index].catSubCategory != Constant.catQuarantineAtHome);
  }

  _itemOfWeekGoal(int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 8,
      child: Column(
        children: [
          (isAvailableHistory.isNotEmpty && !isAvailableHistory[index])
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.5, color: Colors.black)),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        Utils.getDaysDateOfWeek(Preference.shared.getInt(
                            Preference.SELECTED_FIRST_DAY_OF_WEEK)??0)[index]
                            .toString(),
                        textAlign: TextAlign.center,
                      )),
                )
              : Container(
                  alignment: Alignment.center,
                  child:
                      Image.asset("assets/icons/ic_challenge_complete_day.png",scale: 3,))
        ],
      ),
    );
  }

  _widgetDiscover(){
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DiscoverScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20,left: 20,top: 5,bottom: 20),
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg_libray.webp'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colur.transparent_black_50,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15,right: 15,left: 15,bottom: 5),
                    child: Text(
                      Languages.of(context)!.txtDiscover.toUpperCase(),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colur.white),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        Languages.of(context)!.txtMoreWorkout,
                        style: TextStyle(color: Colur.transparent_90
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colur.white,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                child: Text(Languages.of(context)!.txtGo+"!"),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getPreference() {
    totalWeekTrainingDays = Preference.shared.getString(Preference.SELECTED_TRAINING_DAY) ?? "4";
  }
  @override
  void onTopBarClick(String name, {bool value = true}) {}

  _getDataFromDatabase(){
    _getAllPlanList();
    _getTotalQuarantineWorkout();
    _getTotalWorkoutDetail();
    _getTotalQuarantineWorkout();
    _getHistoryWeekWise();
  }



  _getTotalWorkoutDetail()async{
    totalWorkout = await DataBaseHelper().getHistoryTotalWorkout() ?? 0;
    totalKcal = await DataBaseHelper().getHistoryTotalKCal() ?? 0;
    totalMin = await DataBaseHelper().getHistoryTotalMinutes() ?? 0;
    setState(() {

    });
  }

  _getAllPlanList() async{
    allPlanDataList = await DataBaseHelper().getHomePlanData();
    allPlanDataList.forEach((element) {
      Debug.printLog("_getAllPlanList==>> "+element.catName.toString());
    });
    setState(() {});
  }

  _getTotalQuarantineWorkout() async {
    totalQuarantineWorkout = await DataBaseHelper().getTotalWorkoutQuarantineAtHome();
    Debug.printLog(
        "totalQuarantineWorkout==>> " + totalQuarantineWorkout.toString());
    setState(() {});
  }


  _getHistoryWeekWise() {
    int? tempInt= 0;
    Utils.getDaysDateForHistoryOfWeek().forEach((element) async {
      bool? isAvailable = await DataBaseHelper().isHistoryAvailableDateWise(element.toString());
      isAvailableHistory.add(isAvailable!);
      if(isAvailable){
        tempInt = tempInt!+1;
        if(int.parse(Preference.shared.getString(Preference.SELECTED_TRAINING_DAY)!) >= tempInt!) {
          totalDayOfWeekGoal = totalDayOfWeekGoal! + 1;
        }
      }
      Debug.printLog("getDaysDateForHistoryOfWeek==>> "+element.toString());
    });
    isAvailableHistory.forEach((element) {
      Debug.printLog("isAvailableHistory==>> "+element.toString());
    });
    setState(() {});
  }


  Future<int?> _setDayProgressDataByPlan(String strTableName) async {
    if(strTableName == Constant.tbl_full_body_workouts_list || strTableName == Constant.tbl_lower_body_list) {
      List<FullBodyWorkoutTable> compDay =
      await DataBaseHelper().getCompleteDayCountByTableName(strTableName);
      String proPercentage =
      (compDay.length.toDouble() * 100 / 30).toDouble().toStringAsFixed(0);
      progress = proPercentage + "%";
      return double.parse(proPercentage).toInt();
    }else{
      return 0;
    }
  }

  Future<String?> _setLeftDayProgressDataByPlan(String strTableName) async {
    if(strTableName == Constant.tbl_full_body_workouts_list || strTableName == Constant.tbl_lower_body_list) {
      List<FullBodyWorkoutTable> compDay =
      await DataBaseHelper().getCompleteDayCountByTableName(strTableName);
      String daysLeft = (30 - compDay.length).toString();
      return daysLeft + " " + Languages.of(context)!.txtDayLeft;
    }else{
      return "";
    }
  }

  Future<String?> _setDayProgressPercentagePlan(String strTableName) async {
    if (strTableName == Constant.tbl_full_body_workouts_list ||
        strTableName == Constant.tbl_lower_body_list) {
      List<FullBodyWorkoutTable> compDay =
          await DataBaseHelper().getCompleteDayCountByTableName(strTableName);
      String proPercentage =
          (compDay.length.toDouble() * 100 / 30).toDouble().toStringAsFixed(0);
      return proPercentage + "%";
    } else {
      return "";
    }
  }
}

