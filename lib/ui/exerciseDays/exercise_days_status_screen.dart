import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/custom/drawer/drawer_menu.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/database/model/WeeklyDayData.dart';
import 'package:homeworkout_flutter/database/tables/fullbody_workout_table.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/training_plan/training_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/preference.dart';

class ExerciseDaysStatusScreen extends StatefulWidget {

  final String? planName;

  ExerciseDaysStatusScreen({this.planName=""});
  @override
  _ExerciseDaysStatusScreenState createState() => _ExerciseDaysStatusScreenState();
}

class _ExerciseDaysStatusScreenState extends State<ExerciseDaysStatusScreen> {
  ScrollController? _scrollController;
  List<WeeklyDayData> weeklyDataList = [];
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
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TrainingScreen()), (route) => false);
          return Future.value(true);
        },
        child: SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: Scaffold(
            drawer: DrawerMenu(),
            body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 2,
                      titleSpacing: -5,
                      expandedHeight: 140.0,
                      floating: false,
                      pinned: true,
                      leading: InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.menu,
                              color: isShrink ? Colur.black : Colur.white,
                            ),
                          )
                      ),
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          widget.planName.toString().toUpperCase(),
                          style: TextStyle(
                            color: isShrink ? Colur.black : Colur.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        background: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    // 'assets/images/abs_advanced.webp',
                                    (widget.planName!.toUpperCase() ==
                                            Constant.Full_body_small.toUpperCase())
                                        ? "assets/exerciseImage/other/full_body_${Preference.shared.getString(Constant.SELECTED_GENDER)??Constant.GENDER_MEN}.webp"
                                        : "assets/exerciseImage/other/lower_body_${Preference.shared.getString(Constant.SELECTED_GENDER)??Constant.GENDER_MEN}.webp",
                                  ),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    /*Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Text(
                                          "28 ${Languages.of(context)!.txtDaysLeft}",
                                          style: TextStyle(
                                              color: Colur.white, fontSize: 14.0)),
                                    ),*/

                                    FutureBuilder(
                                      future: _setLeftDayProgressDataByPlan(widget.planName.toString()),
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
                                      /*child: Container(
                                        alignment: Alignment.centerRight,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Text("10%",
                                            style: TextStyle(
                                                color: Colur.white,
                                                fontSize: 14.0)),
                                      ),*/

                                      child: FutureBuilder(
                                        future: _setDayProgressPercentagePlan(widget.planName.toString()),
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
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 10, top: 10, bottom: 20),
                                /*child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: LinearProgressIndicator(
                                    value: (10 / 100).toDouble(),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colur.theme),
                                    backgroundColor: Colur.transparent_50,
                                    minHeight: 5,
                                  ),
                                ),*/

                                child:  FutureBuilder(
                                  future: _setDayProgressDataByPlan(widget.planName.toString()),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasData) {
                                      return
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: LinearProgressIndicator(
                                            value: (snapshot.data / 100).toDouble(),
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(Colur.theme),
                                            backgroundColor: Colur.transparent_50,
                                            minHeight: 5,
                                          ),
                                        );
                                    }else {
                                      return Container();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                    color: Colur.iconGreyBg,
                    child: Column(
                      children: [
                        _widgetListOfDays(),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            gradient: LinearGradient(
                                colors: [
                                  Colur.blueGradientButton1,
                                  Colur.blueGradientButton2,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: TextButton(
                            child: Text(
                              Languages.of(context)!.txtGo.toUpperCase(),
                              style: TextStyle(
                                color: Colur.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExerciseListScreen(fromPage: Constant.PAGE_DAYS_STATUS,
                                        weeklyDayData: weeklyDataList[weekPosition],
                                        dayName: weeklyDataList[weekPosition]
                                            .arrWeekDayData![weekDaysPosition]
                                            .dayName,
                                        weekName: (weekPosition + 1).toString(),
                                        planName:widget.planName ,))).then((value) {
                                          _getDataFromDatabase();
                                          setState(() {   });
                              });
                            },
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
  var weekPosition = 0;
  var weekDaysPosition = 0;
  _widgetListOfDays() {
    return Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: weeklyDataList.length,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (BuildContext context, int index) {

          return itemListDays(index);
        },
      ),
    );
  }
  var isShow = false;
  itemListDays(int index) {
    var mainIndex = index;
    var boolFlagWeekComplete = index == 0 || weeklyDataList[index-1].isCompleted == "1" ;
    if(boolFlagWeekComplete){
      weekPosition = index;
    }
    var count = 0;
    for (int i=0; i < weeklyDataList[mainIndex].arrWeekDayData!.length-1;i++) {
      if (weeklyDataList[index].arrWeekDayData![i].isCompleted == "1") {
        count++;
      }
    }
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (boolFlagWeekComplete)?Colur.theme:Colur.gray,
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: Colur.white,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    Languages.of(context)!.txtweek +
                        " " +
                        weeklyDataList[index]
                            .weekName
                            .toString()
                            .replaceAll("0", ""),
                    style: TextStyle(
                        color:
                            (boolFlagWeekComplete) ? Colur.theme : Colur.gray),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Visibility(
                  visible: boolFlagWeekComplete,
                  // visible: index == 0 || weeklyDataList[index -1].Is_completed == "1",
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colur.black),
                      children: <TextSpan>[
                        TextSpan(text: '${count.toString()}', style: TextStyle(color: Colur.theme)),
                        TextSpan(text: '/7'),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
          Row(
            children: [
              Visibility(
                visible: weeklyDataList[index].weekName != "04",
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 130,
                  child: VerticalDivider(
                    color: (boolFlagWeekComplete)?Colur.theme:Colur.gray,
                    width: 1,
                    thickness: 1,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin:  EdgeInsets.only(left: (weeklyDataList[index].weekName == "04")?30:20, right:5),
                  alignment: Alignment.center,
                  color: Colur.white,
                  height: 125,
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 105,
                              childAspectRatio: 3 / 1.2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 10),
                      padding: const EdgeInsets.all(0),
                      itemCount: 8,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, index) {
                        return _itemOfDays(index, mainIndex,boolFlagWeekComplete);
                      }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _itemOfDays(int index,int mainIndex, bool boolFlagWeekComplete) {



    var flagPrevDay = weeklyDataList[mainIndex].arrWeekDayData!.isNotEmpty && index != 7 && index != 0 &&
        weeklyDataList[mainIndex].arrWeekDayData![index-1].isCompleted == "1" &&
        weeklyDataList[mainIndex].arrWeekDayData![index+1].isCompleted == "0";
    Debug.printLog("flagPrevDay==>>  "+flagPrevDay.toString()+"  "+index.toString());

    if((weeklyDataList[mainIndex].arrWeekDayData!.isNotEmpty &&
        weeklyDataList[mainIndex].arrWeekDayData![index].isCompleted != "1" && flagPrevDay) ||
        (index == 0 && boolFlagWeekComplete)){
      weekDaysPosition = index;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (weeklyDataList[mainIndex].arrWeekDayData!.isNotEmpty &&
            weeklyDataList[mainIndex].arrWeekDayData![index].isCompleted == "1" && index != 7) ...{
          Container(
            alignment: Alignment.center,
            height: 60,
            width: 60,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colur.theme),
            child: Icon(
              Icons.done_rounded,
              size: 20,
              color: Colur.white,
            ),
          )
        }
        else if (index == 7 && index != 0) ...{
          Container(
            alignment: Alignment.center,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        (weeklyDataList[mainIndex].isCompleted == "1")
                            ? "assets/images/ic_challenge_complete.png"
                            : "assets/images/ic_challenge_uncomplete.webp"),
                    scale: 5)),
            /*child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Text(
          (mainIndex + 1).toString(),
          style: TextStyle(fontSize: 18, color: Colur.disableTxtColor),
        )),*/
          )
        }
        else if ((weeklyDataList[mainIndex].arrWeekDayData!.isNotEmpty &&
              weeklyDataList[mainIndex].arrWeekDayData![index].isCompleted != "1" && flagPrevDay) ||
              (index == 0 && boolFlagWeekComplete)) ...{

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExerciseListScreen(
                          fromPage: Constant.PAGE_DAYS_STATUS,
                          weeklyDayData: weeklyDataList[mainIndex],
                          dayName: weeklyDataList[mainIndex]
                              .arrWeekDayData![index]
                              .dayName,
                          weekName: (mainIndex + 1).toString(),
                          planName:widget.planName ,
                        )));
              },
              child: DottedBorder(
                color: Colur.theme,
                borderType: BorderType.Circle,
                strokeWidth: 1.5,
                strokeCap: StrokeCap.butt,
                dashPattern: [5, 3, 5, 3, 5, 3],
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(color: Colur.theme, fontSize: 18),
                  ),
                ),
              ),
            )

          }
          else ...{
              Container(
                alignment: Alignment.center,
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(color: Colur.grey_icon),
                  border: Border.all(color: Colur.disableTxtColor),
                ),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(color: Colur.disableTxtColor, fontSize: 18),
                ),
              )
            },

        Expanded(
          child: Visibility(
            visible: ((index == 3) || (index == 7)) ? false : true,
            child: Icon(
              Icons.navigate_next_rounded,
              color: (weeklyDataList[mainIndex].arrWeekDayData!.isNotEmpty &&
                  weeklyDataList[mainIndex].arrWeekDayData![index].isCompleted == "1"
                  )
                  ? Colur.theme : Colur.disableTxtColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }


  _getDataFromDatabase()async{
    weeklyDataList = await DataBaseHelper().getWorkoutWeeklyData(widget.planName.toString());
    weeklyDataList.forEach((element) {
      Debug.printLog("_getWeeklyData==>> "+element.weekName.toString()+"  "+element.dayName.toString());
      element.arrWeekDayData!.forEach((element1) {
        Debug.printLog("arrWeekDayData==>>  "+element1.dayName.toString()+"  "+element1.isCompleted.toString());
      });
    });
    setState(() {});
  }


  Future<int?> _setDayProgressDataByPlan(String strTableName) async {
    // if(strTableName == Constant.tbl_full_body_workouts_list || strTableName == Constant.tbl_lower_body_list) {
    String? tableName = "";
    if(strTableName.toUpperCase() == Constant.Full_body_small.toUpperCase()){
      tableName = Constant.tbl_full_body_workouts_list;
    }else{
      tableName = Constant.tbl_lower_body_list;
    }
      List<FullBodyWorkoutTable> compDay =
      await DataBaseHelper().getCompleteDayCountByTableName(tableName);
      String proPercentage =
      (compDay.length.toDouble() * 100 / 30).toDouble().toStringAsFixed(0);
      return double.parse(proPercentage).toInt();
    /*}else{
      return 0;
    }*/
  }

  Future<String?> _setLeftDayProgressDataByPlan(String strTableName) async {
    // if(strTableName == Constant.tbl_full_body_workouts_list || strTableName == Constant.tbl_lower_body_list) {
      String? tableName = "";
      if(strTableName.toUpperCase() == Constant.Full_body_small.toUpperCase()){
        tableName = Constant.tbl_full_body_workouts_list;
      }else{
        tableName = Constant.tbl_lower_body_list;
      }
      List<FullBodyWorkoutTable> compDay =
      await DataBaseHelper().getCompleteDayCountByTableName(tableName);
      String daysLeft = (30 - compDay.length).toString();
      return daysLeft + " " + Languages.of(context)!.txtDayLeft;
    /*}else{
      return "";
    }*/
  }

  Future<String?> _setDayProgressPercentagePlan(String strTableName) async {
    /*if (strTableName == Constant.tbl_full_body_workouts_list ||
        strTableName == Constant.tbl_lower_body_list) {*/
      String? tableName = "";
      if(strTableName.toUpperCase() == Constant.Full_body_small.toUpperCase()){
        tableName = Constant.tbl_full_body_workouts_list;
      }else{
        tableName = Constant.tbl_lower_body_list;
      }
      List<FullBodyWorkoutTable> compDay =
      await DataBaseHelper().getCompleteDayCountByTableName(tableName);
      String proPercentage =
      (compDay.length.toDouble() * 100 / 30).toDouble().toStringAsFixed(0);
      return proPercentage + "%";
    /*} else {
      return "";
    }*/
  }
}
