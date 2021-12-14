import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/database/tables/history_table.dart';
import 'package:homeworkout_flutter/database/tables/history_week_data.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/report/report_screen.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class WorkoutHistoryScreen extends StatefulWidget {
  final bool? isFromWorkOut;

  const WorkoutHistoryScreen({Key? key, this.isFromWorkOut}) : super(key: key);

  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen>
    implements TopBarClickListener {
  var currentDate = DateTime.now();
  var currentDay =
      DateFormat('EEEE', getLocale().languageCode).format(DateTime.now());
  var startDateOfCurrentWeek;
  var endDateOfCurrentWeek;
  var formatStartDateOfCurrentWeek;
  var formatEndDateOfCurrentWeek;
  HistoryWeekData? historyWeekDataClass = HistoryWeekData();

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  int? totalWorkouts = 4;
  int? totalDuration = 0;
  double? totalKcal = 0.0;

  List<HistoryTable> currentWeekHistoryData = [];
  List<HistoryTable> historyData = [];
  List<HistoryWeekData> historyWeekData = [];

  List calendarDates = [];

  @override
  void initState() {
    getDataFromDatabase();
    startDateOfCurrentWeek =
        getDate(currentDate.subtract(Duration(days: currentDate.weekday - 1)));
    endDateOfCurrentWeek = getDate(currentDate
        .add(Duration(days: DateTime.daysPerWeek - currentDate.weekday)));
    formatStartDateOfCurrentWeek = DateFormat.MMMd(getLocale().languageCode)
        .format(startDateOfCurrentWeek);
    formatEndDateOfCurrentWeek =
        DateFormat.MMMd(getLocale().languageCode).format(endDateOfCurrentWeek);
    Debug.printLog(formatStartDateOfCurrentWeek);
    Debug.printLog(formatEndDateOfCurrentWeek);
    Debug.printLog(startDateOfCurrentWeek.toString().split(" ")[0] +
        endDateOfCurrentWeek.toString().split(" ")[0]);


    // getDataFromDatabase();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ), //
      ),
      child: WillPopScope(
        onWillPop:() async{
          _backToReportScreen();
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar( // Here we create one to set status bar color
                backgroundColor: Colur.bg_white,
                elevation: 0,
              )
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  child: CommonTopBar(
                    Languages.of(context)!.txtHistory.toUpperCase(),
                    this,
                    isShowBack: true,
                  ),
                ),
                //=======History screen========
                historyScreenWidget(fullWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }

  historyScreenWidget(double fullWidth) {
    return Expanded(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            //======Calendar==========
            calendarWidget(fullWidth),

            workoutPlansHistory(),
          ],
        ),
      ),
    );
  }

  workoutPlansHistory() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: historyWeekData.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            //=====thick divider=========
            Divider(
              color: Colur.txt_gray.withOpacity(0.2),
              thickness: 10,
            ),
            //=========date, no. of workout, total duration and calories for week=========
            weekTotalDataWidget(historyWeekData[index]),
            //======divider=========
            Divider(
              color: Colur.txt_gray,
            ),
            //=========completed workout plans===========
            weeklyWorkoutPlansWidget(historyWeekData[index].arrHistoryDetail),
          ],
        );
      },
    );
  }

  calendarWidget(double fullWidth) {
    return TableCalendar(
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day){
        //Debug.printLog("==>" + day.toString() + calendarDates.contains(day).toString());
        if(day == DateTime.parse(DateTime.parse(DateTime.now().toString().split(" ")[0]).toString() + "Z")) {
          return false;
        } else {
          return calendarDates.contains(day);
        }

      },
      calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: Colur.txt_gray),
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colur.transparent,
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colur.theme_trans,
          ),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colur.theme
          ),
          selectedTextStyle:
              TextStyle(fontWeight: FontWeight.w400, color: Colur.white),
          todayTextStyle:
              TextStyle(fontWeight: FontWeight.w400, color: Colur.theme)),
      headerVisible: true,
      headerStyle: HeaderStyle(
          leftChevronVisible: false,
          rightChevronVisible: false,
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMM(locale).format(date),
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          leftChevronIcon: Image.asset(
            "assets/icons/ic_calendar_left_arrow.png",
            color: Colur.theme,
            scale: 1.7,
          ),
          rightChevronIcon: Image.asset(
            "assets/icons/ic_calendar_right_arrow.png",
            color: Colur.theme,
            scale: 1.7,
          ),
          headerMargin: EdgeInsets.only(
              left: fullWidth * 0.25, right: fullWidth * 0.25, bottom: 10)),
      startingDayOfWeek: StartingDayOfWeek.monday,

      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle:
              TextStyle(color: Colur.txt_gray, fontWeight: FontWeight.w600),
          weekendStyle:
              TextStyle(color: Colur.txt_gray, fontWeight: FontWeight.w600)),
      firstDay: DateTime(1900, 01, 01),
      focusedDay: DateTime.now(),
      lastDay: DateTime(2100, 12, 31),
    );
  }

  DateFormat dateFormat = DateFormat();

  convertStringFromDate(String date) {
    final todayDate = DateTime.parse(date);
    /*print(formatDate(todayDate,
        [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss, ' ', am]));*/
    return formatDate(todayDate, [MM.substring(1), ' ', dd]);
  }

  convertStringFromDateWithTime(String date) {
    final todayDate = DateTime.parse(date);
    return formatDate(
        todayDate, [MM.substring(1), ' ', dd, ', ', hh, ':', nn, ' ', am]);
  }

  weekTotalDataWidget(HistoryWeekData historyWeekData) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //===========date and no. of workouts in current week===========
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========start & end date of week=======
              Text(
                  convertStringFromDate(historyWeekData.weekStart.toString()) +
                      " : " +
                      convertStringFromDate(historyWeekData.weekEnd.toString()),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colur.black,
                    fontSize: 15,
                  )),
              //=========no. of workouts=========
              Text(
                  historyWeekData.totWorkout.toString() +
                      " " +
                      Languages.of(context)!.txtWorkout,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colur.txt_gray,
                    fontSize: 13,
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========duration=======
              Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_workout_time.png",
                    scale: 1.2,
                    color: Colur.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      Utils.secondToMMSSFormat(int.parse(
                          historyWeekData.totTime!.round().toString())),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colur.black,
                        fontSize: 13,
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              //=========calories=========
              Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_workout_calories.png",
                    scale: 1.2,
                    color: Colur.orange,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      historyWeekData.totKcal.toString() +
                          " " +
                          Languages.of(context)!.txtKcal,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colur.black,
                        fontSize: 13,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  weeklyWorkoutPlansWidget(List<HistoryTable>? arrHistoryDetail) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: arrHistoryDetail!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
              /*var planDaysTable = await DataBaseHelper.instance
                  .getPlanDaysTableById(
                      arrHistoryDetail[index].HPlanId.toString(),
                      arrHistoryDetail[index].HDayName.toString());
              Debug.printLog("arrHistoryDetail[index].HDayName.toString()==>>  " +
                  arrHistoryDetail[index].HDayName.toString());*/
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseListScreen(fromPage: Constant.PAGE_HISTORY,)));

          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset(
                        setPlanImage(arrHistoryDetail, index),
                        scale: 3.5,
                      ),
                    ),
                    //======workout details======
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //=======date and time==========
                            Text(
                                DateFormat.MMMd(getLocale().languageCode)
                                    .format(DateTime.parse(arrHistoryDetail[index].dateTime!))
                                    +", " + arrHistoryDetail[index].completionTime!,

                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 14,
                                )),
                            //=========exercise name======
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  /*currentWeekHistoryData[index].HLvlName! + " " +
                                    Languages.of(context)!.txtDay + " " + currentWeekHistoryData[index].HDayName!*/
                                  /*arrHistoryDetail[index]
                                      .planName
                                      .toString().toUpperCase(),*/
                                getPlanNameFromList(arrHistoryDetail[index])!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colur.black,
                                    fontSize: 16,
                                  )),
                            ),
                            //calorie and duration
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //========duration=======
                                Image.asset(
                                  "assets/icons/ic_workout_time.png",
                                  scale: 1.2,
                                  color: Colur.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    /*calculateDuration(currentWeekHistoryData[index].HDuration!)*/
                                    Utils.secondToMMSSFormat(int.parse(
                                        arrHistoryDetail[index]
                                            .duration
                                            .toString())),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colur.black,
                                      fontSize: 13,
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                //=========calories=========
                                Image.asset(
                                  "assets/icons/ic_workout_calories.png",
                                  scale: 1.2,
                                  color: Colur.orange,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    /*currentWeekHistoryData[index].HBurnKcal! + " " + Languages.of(context)!.txtKcal*/
                                    arrHistoryDetail[index]
                                            .burnKcal
                                            .toString() +
                                        " " +
                                        Languages.of(context)!.txtKcal,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colur.black,
                                      fontSize: 13,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //=========option icon========
                    PopupMenuButton(
                      //initialValue: 0,
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colur.grey_icon,
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 0,
                          height: 30,
                          child: Text(Languages.of(context)!.txtDelete,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colur.orange,
                                fontSize: 16,
                              )),
                        )
                      ],
                      onSelected: (value) {
                        if (value == 0 && value != null) {
                          _deleteExerciseDialog(arrHistoryDetail[index].id!);
                        }
                      },
                    )
                  ],
                ),
                Divider(
                  color: Colur.lightGrey,
                )
              ],
            ),
          ),
        );
      },
    );
  }


  String? getPlanNameFromList(HistoryTable arrHistoryDetail){
    String? planName = "";
    if(arrHistoryDetail.tableName == Constant.tbl_full_body_workouts_list ||
        arrHistoryDetail.tableName == Constant.tbl_lower_body_list){
      planName = arrHistoryDetail.planName.toString() +
          " - " +
          Languages.of(context)!.txtDay +
          " " +
          arrHistoryDetail.dayName!.replaceAll("0", "");
    }else{
      planName = arrHistoryDetail.planName.toString();
    }
    return planName.toUpperCase();
  }

  String setPlanImage(List<HistoryTable> arrHistoryDetail, int index) {

    if (arrHistoryDetail[index].fromPage.toString() == Constant.PAGE_DISCOVER) {
      return "assets/icons/history/ic_history_discover.webp";
    } else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_full_body_workouts_list) {
      return "assets/icons/history/ic_history_full_body.webp";
    } else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_lower_body_list) {
      return "assets/icons/history/ic_history_lower.webp";
    }else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_abs_beginner || arrHistoryDetail[index].tableName.toString()== Constant.tbl_abs_intermediate || arrHistoryDetail[index].tableName.toString()== Constant.tbl_abs_advanced) {
      return "assets/icons/history/ic_history_abs.webp";
    }else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_chest_beginner || arrHistoryDetail[index].tableName.toString()== Constant.tbl_chest_intermediate || arrHistoryDetail[index].tableName.toString()== Constant.tbl_chest_advanced) {
      return "assets/icons/history/ic_history_chest.webp";
    }else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_arm_beginner || arrHistoryDetail[index].tableName.toString()== Constant.tbl_arm_intermediate || arrHistoryDetail[index].tableName.toString()== Constant.tbl_arm_advanced) {
      return "assets/icons/history/ic_history_arm.webp";
    }else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_leg_beginner || arrHistoryDetail[index].tableName.toString()== Constant.tbl_leg_intermediate || arrHistoryDetail[index].tableName.toString()== Constant.tbl_leg_advanced) {
      return "assets/icons/history/ic_history_leg.webp";
    }else if (arrHistoryDetail[index].tableName.toString()== Constant.tbl_shoulder_back_beginner || arrHistoryDetail[index].tableName.toString()== Constant.tbl_shoulder_back_intermediate || arrHistoryDetail[index].tableName.toString()== Constant.tbl_shoulder_back_advanced) {
      return "assets/icons/history/ic_history_shoulder.webp";
    } else{
      return "assets/icons/history/ic_history_discover.webp";
    }
  }

  List<DateTime> dates = [];

  getDataFromDatabase() async {
    historyData = await DataBaseHelper().getHistoryData();
    historyData.forEach((element) {
      dates.add(DateTime.parse(element.dateTime!));
    });
    historyWeekData = await DataBaseHelper.instance.getHistoryWeekData();

    setState(() {});
    historyWeekData.forEach((element) {
      element.arrHistoryDetail!.forEach((element1) {
        Debug.printLog("History::Plan::==>  " +
            element1.id.toString() +
            "  " +
            element1.dayName.toString());

        calendarDates.add(DateTime.parse(DateTime.parse(element1.dateTime!.split(" ")[0]).toString() + "Z"));
      });
    });

    Debug.printLog(calendarDates.toString());
  }

  void _deleteExerciseDialog(int id) {
    Widget cancelButton = TextButton(
      child: Text(Languages.of(context)!.txtCancel.toUpperCase(),
          style: TextStyle(color: Colur.theme)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text(
        Languages.of(context)!.txtOk.toUpperCase(),
        style: TextStyle(color: Colur.theme),
      ),
      onPressed: () {
        DataBaseHelper()
            .deleteHistoryData(id)
            .then((value) {
          getDataFromDatabase();
          setState(() {});
        });
        Navigator.pop(context);
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(Languages.of(context)!.txtDelete),
            content: new Text(Languages.of(context)!.txtDeleteExe),
            actions: [cancelButton, okButton],
          );
        });
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if(name == Constant.strBack){
      _backToReportScreen();
    }
  }

  _backToReportScreen() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => ReportScreen()), (
        route) => false);
  }
}
