import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homeworkout_flutter/common/commonTopBar/commom_topbar.dart';
import 'package:homeworkout_flutter/database/tables/history_table.dart';
import 'package:homeworkout_flutter/database/tables/history_week_data.dart';
import 'package:homeworkout_flutter/database/database_helper.dart';
import 'package:homeworkout_flutter/interfaces/topbar_clicklistener.dart';
import 'package:homeworkout_flutter/localization/language/languages.dart';
import 'package:homeworkout_flutter/localization/locale_constant.dart';
import 'package:homeworkout_flutter/ui/exerciselist/ExerciseListScreen.dart';
import 'package:homeworkout_flutter/ui/report/report_screen.dart';
import 'package:homeworkout_flutter/utils/ad_helper.dart';
import 'package:homeworkout_flutter/utils/color.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/preference.dart';
import 'package:homeworkout_flutter/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final bool? isFromWorkOut;
  final bool? isFromTraining;

  const WorkoutHistoryScreen(
      {Key? key, this.isFromWorkOut = false, this.isFromTraining = false})
      : super(key: key);

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

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(
          nonPersonalizedAds: Utils.nonPersonalizedAds()
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

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

    _createBottomBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fullWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      child: WillPopScope(
        onWillPop: () async {
          _backToReportScreen();
          return false;
        },
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                backgroundColor: Colur.bg_white,
                elevation: 0,
              )),
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
                historyScreenWidget(fullWidth),
                (_isBottomBannerAdLoaded && !Utils.isPurchased())
                    ? Container(
                        height: _bottomBannerAd.size.height.toDouble(),
                        width: _bottomBannerAd.size.width.toDouble(),
                        child: AdWidget(ad: _bottomBannerAd),
                      )
                    : Container()
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
            Divider(
              color: Colur.txt_gray.withOpacity(0.2),
              thickness: 10,
            ),
            weekTotalDataWidget(historyWeekData[index]),
            Divider(
              color: Colur.txt_gray,
            ),
            weeklyWorkoutPlansWidget(historyWeekData[index].arrHistoryDetail),
          ],
        );
      },
    );
  }

  calendarWidget(double fullWidth) {
    return TableCalendar(
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) {
        if (day ==
            DateTime.parse(
                DateTime.parse(DateTime.now().toString().split(" ")[0])
                        .toString() +
                    "Z")) {
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
          selectedDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colur.theme),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  convertStringFromDate(historyWeekData.weekStart.toString()) +
                      " : " +
                      convertStringFromDate(historyWeekData.weekEnd.toString()),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colur.black,
                    fontSize: 15,
                  )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/ic_workout_time.webp",
                    height: 20,
                    width: 20,
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
              Row(
                children: [
                  Image.asset(
                    "assets/icons/ic_workout_calories.webp",
                    height: 20,
                    width: 20,
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
            var homePlanTable;
            var discoverPlanTable;
            if (arrHistoryDetail[index].fromPage == Constant.PAGE_HOME) {
              homePlanTable = await DataBaseHelper().getHomePlanDataForHistory(
                  arrHistoryDetail[index].tableName!);
            } else if (arrHistoryDetail[index].fromPage ==
                Constant.PAGE_DISCOVER) {
              discoverPlanTable = await DataBaseHelper()
                  .getDiscoverPlanDataForHistory(
                      arrHistoryDetail[index].planId!);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExerciseListScreen(
                          fromPage: arrHistoryDetail[index].fromPage,
                          planName: arrHistoryDetail[index].planName,
                          discoverPlanTable: discoverPlanTable,
                          isSubPlan: false,
                          homePlanTable: homePlanTable,
                          dayName: arrHistoryDetail[index].dayName,
                          weekName: arrHistoryDetail[index].weekName,
                          isFromOnboarding: false,
                          isFromHistory: true,
                        )));
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                DateFormat.MMMd(getLocale().languageCode)
                                        .format(DateTime.parse(
                                            arrHistoryDetail[index]
                                                .dateTime!)) +
                                    ", " +
                                    arrHistoryDetail[index].completionTime!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colur.txt_gray,
                                  fontSize: 14,
                                )),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  getPlanNameFromList(arrHistoryDetail[index])!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colur.black,
                                    fontSize: 16,
                                  )),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/ic_workout_time.webp",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3.5),
                                  child: Text(
                                      Utils.secondToMMSSFormat(int.parse(
                                          arrHistoryDetail[index]
                                              .duration
                                              .toString())),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colur.black,
                                        fontSize: 13,
                                      )),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Image.asset(
                                  "assets/icons/ic_workout_calories.webp",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3.5),
                                  child: Text(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

  String? getPlanNameFromList(HistoryTable arrHistoryDetail) {
    String? planName = "";
    if (arrHistoryDetail.tableName == Constant.tbl_full_body_workouts_list ||
        arrHistoryDetail.tableName == Constant.tbl_lower_body_list) {
      planName = arrHistoryDetail.planName.toString() +
          " - " +
          Languages.of(context)!.txtDay +
          " " +
          arrHistoryDetail.dayName!.replaceAll(RegExp(r'^0+(?=.)'), '');
    } else {
      planName = arrHistoryDetail.planName.toString();
    }
    return planName.toUpperCase();
  }

  String setPlanImage(List<HistoryTable> arrHistoryDetail, int index) {
    if (arrHistoryDetail[index].fromPage.toString() == Constant.PAGE_DISCOVER) {
      return "assets/icons/history/ic_history_discover.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
        Constant.tbl_full_body_workouts_list) {
      return "assets/icons/history/ic_history_full_body.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
        Constant.tbl_lower_body_list) {
      return "assets/icons/history/ic_history_lower.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_abs_beginner ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_abs_intermediate ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_abs_advanced) {
      return "assets/icons/history/ic_history_abs.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_chest_beginner ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_chest_intermediate ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_chest_advanced) {
      return "assets/icons/history/ic_history_chest.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_arm_beginner ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_arm_intermediate ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_arm_advanced) {
      return "assets/icons/history/ic_history_arm.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_leg_beginner ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_leg_intermediate ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_leg_advanced) {
      return "assets/icons/history/ic_history_leg.webp";
    } else if (arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_shoulder_back_beginner ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_shoulder_back_intermediate ||
        arrHistoryDetail[index].tableName.toString() ==
            Constant.tbl_shoulder_back_advanced) {
      return "assets/icons/history/ic_history_shoulder.webp";
    } else {
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
        calendarDates.add(DateTime.parse(
            DateTime.parse(element1.dateTime!.split(" ")[0]).toString() + "Z"));
      });
    });
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      _backToReportScreen();
    }
  }

  _backToReportScreen() {
    if (!widget.isFromTraining!) {
      Preference.shared.setInt(Preference.DRAWER_INDEX, 2);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => ReportScreen()),
          (route) => false);
    } else {
      Navigator.of(context).pop();
    }
  }
}
