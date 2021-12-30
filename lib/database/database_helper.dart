import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/model/DiscoverSingleExerciseData.dart';
import 'package:homeworkout_flutter/database/model/ExerciseListData.dart';
import 'package:homeworkout_flutter/database/model/WeeklyDayData.dart';
import 'package:homeworkout_flutter/database/tables/discover_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/fullbody_workout_table.dart';
import 'package:homeworkout_flutter/database/tables/history_table.dart';
import 'package:homeworkout_flutter/database/tables/history_week_data.dart';
import 'package:homeworkout_flutter/database/tables/home_plan_table.dart';
import 'package:homeworkout_flutter/database/tables/reminder_table.dart';
import 'package:homeworkout_flutter/database/tables/weight_table.dart';
import 'package:homeworkout_flutter/utils/constant.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

import 'model/WeekDayData.dart';
import 'model/WorkoutDetailData.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper.internal();

  factory DataBaseHelper() => instance;

  Database? _db;

  DataBaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  init() async {
    var dbPath = await getDatabasesPath();
    Debug.printLog("getDatabasesPath ===>" + dbPath.toString());

    String dbPathHomeWorkout = path.join(dbPath, "HomeWorkoutFlutter.db");
    Debug.printLog("dbPathEnliven ===>" + dbPathHomeWorkout.toString());

    bool dbExistsEnliven = await io.File(dbPathHomeWorkout).exists();

    if (!dbExistsEnliven) {
      ByteData data = await rootBundle
          .load(path.join("assets/database", "HomeWorkoutFlutter.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(dbPathHomeWorkout).writeAsBytes(bytes, flush: true);
    }

    return _db = await openDatabase(dbPathHomeWorkout);
  }

  String absAdvancedTable = "tbl_abs_advanced";
  String absBeginnerTable = "tbl_abs_beginner";
  String absIntermediateTable = "tbl_abs_intermediate";

  String armAdvancedTable = "tbl_arm_advanced";
  String armBeginnerTable = "tbl_arm_beginner";
  String armIntermediateTable = "tbl_arm_intermediate";

  String chestAdvancedTable = "tbl_chest_advanced";
  String chestBeginnerTable = "tbl_chest_beginner";
  String chestIntermediateTable = "tbl_chest_intermediate";

  String legAdvancedTable = "tbl_leg_advanced";
  String legBeginnerTable = "tbl_leg_beginner";
  String legIntermediateTable = "tbl_leg_intermediate";

  String shoulderAdvancedTable = "tbl_shoulder_back_advanced";
  String shoulderBeginnerTable = "tbl_shoulder_back_beginner";
  String shoulderIntermediateTable = "tbl_shoulder_back_intermediate";

  String bwExerciseTable = "tbl_bw_exercise";
  String fullBodyWorkoutTable = "tbl_full_body_workouts_list";
  String lowerBodyTable = "tbl_lower_body_list";

  String historyTable = "tbl_history";
  String weightTable = "tbl_Weight";
  String discoverPlanTable = "DiscoverPlanTable";
  String homePlanTable = "HomePlanTable";
  String homeExSingleTable = "HomeExSingleTable";
  String exerciseTable = "ExerciseTable";
  String reminderTable = "tbl_reminder";

  Future<List<HomePlanTable>> getHomePlanData() async {
    List<HomePlanTable> homePlanList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $homePlanTable");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = HomePlanTable.fromJson(answer);
        homePlanList.add(homePlanData);
      }
    }
    return homePlanList;
  }

  Future<List<DiscoverPlanTable>> getPlanDataCatWise(String catName) async {
    List<DiscoverPlanTable> discoverPlanDataList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $discoverPlanTable where discoverCatName = '$catName' ");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = DiscoverPlanTable.fromJson(answer);
        discoverPlanDataList.add(homePlanData);
      }
    }
    return discoverPlanDataList;
  }

  Future<int?> getTotalWorkoutQuarantineAtHome() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "select count(discoverCatName) from $discoverPlanTable where discoverCatName = '${Constant.QUARANTINE_AT_HOME}'");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<List<DiscoverPlanTable>> getHomeSubPlanList(int parentPlanId) async {
    List<DiscoverPlanTable> discoverPlanDataList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $discoverPlanTable");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = DiscoverPlanTable.fromJson(answer);
        var parentPlanIdsStr = homePlanData.parentPlanId;
        if (parentPlanIdsStr!.isNotEmpty && parentPlanIdsStr != "0") {
          var parentIdList = parentPlanIdsStr.split(",");
          if (parentIdList.isNotEmpty &&
              parentIdList.contains(parentPlanId.toString())) {
            discoverPlanDataList.add(homePlanData);
          }
        }
      }
    }
    return discoverPlanDataList;
  }

  Future<DiscoverPlanTable?> getRandomDiscoverPlan() async {
    List<DiscoverPlanTable> discoverPlanDataList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM  $discoverPlanTable WHERE discoverCatName != '' AND hasSubPlan = 'false' AND planImage != '' AND shortDes != '' ORDER BY RANDOM() LIMIT 1");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = DiscoverPlanTable.fromJson(answer);
        discoverPlanDataList.add(homePlanData);
      }
    }
    return discoverPlanDataList.first;
  }

  Future<List<DiscoverSingleExerciseData>> getDiscoverExercisePlanIdWise(
      String planId) async {
    List<DiscoverSingleExerciseData> discoverPlanDataList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT DX.PlanId,DX.IsCompleted,Dx.ExTime,Dx.ExId,EX.exDescription, EX.exVideo,EX.exPath,EX.exName,Ex.exUnit FROM $homeExSingleTable as DX INNER JOIN $exerciseTable as EX ON(CASE WHEN DX.ExId != ''THEN DX.ExId ELSE DX.ExId END) = EX.ExId WHERE DX.PlanId = '$planId'");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = DiscoverSingleExerciseData.fromJson(answer);
        discoverPlanDataList.add(homePlanData);
      }
    }
    return discoverPlanDataList;
  }

  Future<List<WeeklyDayData>> getWorkoutWeeklyData(
      String strCategoryName) async {
    List<WeeklyDayData> weeklyDataList = [];
    var dbClient = await db;
    var query = "";
    if (strCategoryName == Constant.Full_body_small) {
      query =
          "SELECT  max(Workout_id) as Workout_id, Workout_id, group_concat(DISTINCT(CAST(Day_name as INTEGER))) as Day_name, Week_name, Is_completed from $fullBodyWorkoutTable GROUP BY CAST(Week_name as INTEGER)";
    } else if (strCategoryName == Constant.Lower_body_small) {
      query =
          "SELECT  max(Workout_id) as Workout_id, Workout_id, group_concat(DISTINCT(CAST(Day_name as INTEGER))) as Day_name, Week_name, Is_completed from $lowerBodyTable GROUP BY CAST(Week_name as INTEGER)";
    }
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(query);
    if (maps.length > 0) {
      for (var answer in maps) {
        var weeklyData = WeeklyDayData.fromJson(answer);

        var aClass = WeeklyDayData();
        aClass.workoutId = weeklyData.workoutId;
        aClass.dayName = weeklyData.dayName;
        aClass.weekName = weeklyData.weekName;
        aClass.isCompleted = weeklyData.isCompleted;
        aClass.categoryName = strCategoryName;

        aClass.arrWeekDayData = [];

        var aClass1 = WeekDayData();

        aClass1.dayName = "Cup";

        if (weeklyData.isCompleted == "1") {
          aClass1.isCompleted = "1";
        } else {
          aClass1.isCompleted = "0";
        }

        getWeekDaysData(weeklyData.weekName!, strCategoryName).then((value) => {
              aClass.arrWeekDayData = value,
              aClass.arrWeekDayData!.add(aClass1),
              value.forEach((element) {
                Debug.printLog("getWeekDaysData==>> " +
                    element.isCompleted.toString() +
                    "  " +
                    element.dayName.toString());
              }),
            });

        weeklyDataList.add(aClass);
      }
    }
    return weeklyDataList;
  }

  Future<List<WeekDayData>> getWeekDaysData(
      String strWeekName, String strCategoryName) async {
    List<WeekDayData> arrWeekDayData = [];
    var dbClient = await db;
    var query = "";
    if (strCategoryName == Constant.Full_body_small) {
      query =
          "select Day_name,Is_completed FROM $fullBodyWorkoutTable WHERE Day_name IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28') AND Week_name = '$strWeekName' GROUP by Day_name";
    } else if (strCategoryName == Constant.Lower_body_small) {
      query =
          "select Day_name,Is_completed FROM $lowerBodyTable WHERE Day_name IN ('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28') AND Week_name = '$strWeekName' GROUP by Day_name";
    }
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(query);
    if (maps.length > 0) {
      for (var answer in maps) {
        var weekDayData = WeekDayData.fromJson(answer);
        arrWeekDayData.add(weekDayData);
      }
    }
    return arrWeekDayData;
  }

  Future<List<WorkoutDetail>> getWeekDayExerciseData(
      String strDayName, String strWeekName, String strTableName) async {
    List<WorkoutDetail> exerciseListData = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * from $strTableName WHERE Day_name = '$strDayName' AND Week_name = '0$strWeekName'");
    if (maps.length > 0) {
      for (var answer in maps) {
        var exerciseData = WorkoutDetail.fromJson(answer);
        exerciseListData.add(exerciseData);
      }
    }
    return exerciseListData;
  }

  Future<int> reorderExercise(
      int? workOutId, int sortValue, String tableName) async {
    Map<String, dynamic> row = {
      'sort': sortValue,
    };
    var dbClient = await db;
    var result = await dbClient.update(tableName, row,
        where: 'Workout_id = ?', whereArgs: [workOutId]);
    Debug.printLog("res:reorderExercise ::::::::  $result  $sortValue");
    return result;
  }

  Future<List<ExerciseListData>> getExercisePlanNameWise(
      String tableName) async {
    List<ExerciseListData> exerciseListData = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("Select * from $tableName");
    if (maps.length > 0) {
      for (var answer in maps) {
        var exerciseData = ExerciseListData.fromJson(answer);
        exerciseListData.add(exerciseData);
      }
    }
    return exerciseListData;
  }

  Future<int> insertWeightData(WeightTable weightData) async {
    var dbClient = await db;
    var result = await dbClient.insert(weightTable, weightData.toJson());
    Debug.printLog("res: $result");
    return result;
  }

  Future<List<WeightTable>> getWeightData() async {
    var dbClient = await db;
    List<WeightTable> weightDataList = [];
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $weightTable");
    if (maps.length > 0) {
      for (var answer in maps) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList.add(weightData);
      }
    }
    return weightDataList;
  }

  Future<WeightTable?> getMaxWeight() async {
    var dbClient = await db;
    var weightDataList;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
        "SELECT *, IFNULL(MAX(WeightKG),0), IFNULL(MAX(WeightLB),0) FROM $weightTable");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      return weightDataList;
    }
  }

  Future<WeightTable?> getMinWeight() async {
    var dbClient = await db;
    var weightDataList;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
        "SELECT *, IFNULL(MIN(WeightKG),0), IFNULL(MIN(WeightLB),0) FROM $weightTable");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      return weightDataList;
    }
  }

  Future<WeightTable?> getCurrentWeight(String? date) async {
    Debug.printLog("$date");
    var dbClient = await db;
    var weightDataList;
    List<Map<String, dynamic>> result = await dbClient
        .rawQuery("SELECT * FROM $weightTable WHERE Date = '$date'");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      return weightDataList;
    }
  }

  Future<int?> updateWeight(
      {String? date, double? weightKG, double? weightLBS}) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        " UPDATE $weightTable SET WeightKG = $weightKG, WeightLB = $weightLBS where Date = '$date' ");
    Debug.printLog("res: $result");
    return result;
  }

  Future<int?> updateDayStatusWeekWise(
      String weekName, String dayName, String tableName, String status) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "update $tableName set Is_completed ='$status' where Week_name = '0$weekName' and Day_name = '$dayName'");
    Debug.printLog("updateDayStatusWeekWise::::: $result");
    return result;
  }

  Future<int?> resetProgress() async {
    var dbClient = await db;
    var result = await dbClient
        .rawUpdate("update $fullBodyWorkoutTable set Is_completed ='0'");
    var result1 = await dbClient
        .rawUpdate("update $lowerBodyTable set Is_completed ='0'");
    Debug.printLog("updateDayStatusWeekWise::::: $result  $result1");
    return result;
  }

  Future<int>? insertHistoryData(HistoryTable historyData) async {
    var dbClient = await db;
    var result = await dbClient.insert(historyTable, historyData.toJson());
    Debug.printLog("insertHistoryData:::::: $result  ${historyData.toJson()}");
    return result;
  }

  Future<List<HistoryTable>> getHistoryData() async {
    var dbClient = await db;
    List<HistoryTable> historyDataList = [];
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $historyTable");
    if (maps.length > 0) {
      for (var answer in maps) {
        var historyData = HistoryTable.fromJson(answer);
        historyDataList.add(historyData);
      }
    }
    return historyDataList;
  }

  Future<int?> getTotalWorkoutMinutesForHome(String tableName) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery("Select sum(Time) from $tableName");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<int?> getTotalWorkoutMinutesForDaysStatus(
      String dayName, String weekName, String tableName) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "select sum(Time_beginner) from $tableName where Day_name ='$dayName' and Week_name = '0$weekName'");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<int?> getTotalWorkoutMinutesForDiscover(String planId) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "select sum(ExTime) from $homeExSingleTable where PlanId = '$planId'");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<List<HistoryWeekData>> getHistoryWeekData() async {
    var dbClient = await db;
    List<HistoryWeekData> historyDataList = [];
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "select strftime('%W', DateTime) as weekNumber, max(date(DateTime, 'weekday 0' ,'-6 day')) as weekStart, max(date(DateTime, 'weekday 0', '-0 day')) as weekEnd from $historyTable GROUP BY weekNumber");
    if (maps.length > 0) {
      for (var answer in maps) {
        var historyWeekData = HistoryWeekData();
        var historyData = HistoryWeekData.fromJson(answer);

        historyWeekData.weekNumber = historyData.weekNumber;
        historyWeekData.weekStart = historyData.weekStart;
        historyWeekData.weekEnd = historyData.weekEnd;

        historyWeekData.totKcal = await getTotBurnWeekKcal(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.totTime = await getTotWeekWorkoutTime(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.arrHistoryDetail = await getWeekHistoryData(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.totWorkout = historyWeekData.arrHistoryDetail!.length;
        historyDataList.add(historyWeekData);
      }
    }

    return historyDataList;
  }

  Future<int?> getTotBurnWeekKcal(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT sum(BurnKcal) as HBurnKcalTotal from $historyTable WHERE date('$strWeekStart') <= date(DateTime) AND date('$strWeekEnd') >= date(DateTime)");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<double?> getTotWeekWorkoutTime(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT sum(CAST(duration AS DOUBLE)) as HDuration from $historyTable WHERE date('$strWeekStart') <= date(DateTime) AND date('$strWeekEnd') >= date(DateTime)");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<List<HistoryTable>?> getWeekHistoryData(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<HistoryTable> historyData = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE date('$strWeekStart') <= date(DateTime) AND date('$strWeekEnd') >= date(DateTime) Order by Id Desc");
    if (res.length > 0) {
      for (var answer in res) {
        var waterData = HistoryTable.fromJson(answer);
        historyData.add(waterData);
      }
    }
    return historyData;
  }

  Future<int?> getHistoryTotalWorkout() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(TotalWorkout as INTEGER)) as totWorkout FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<int?> getHistoryTotalMinutes() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(duration as INTEGER)) as HDuration FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<double?> getHistoryTotalKCal() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(BurnKcal as Float)) as HBurnKcal FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0.0;
    }
  }

  Future<bool?> isHistoryAvailableDateWise(String date) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT Id FROM $historyTable WHERE DateTime(strftime('%Y-%m-%d', DateTime(DateTime) ) ) = DateTime(strftime('%Y-%m-%d', DateTime('$date')))");
    if (res.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<FullBodyWorkoutTable>> getCompleteDayCountByTableName(
      String tableName) async {
    var dbClient = await db;
    List<FullBodyWorkoutTable> daysList = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "Select * From $tableName where Is_completed = 1 Group by Day_name");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = FullBodyWorkoutTable.fromJson(answer);
        daysList.add(daysData);
      }
    }
    return daysList;
  }

  Future<HomePlanTable> getHomePlanDataForHistory(String tableName) async {
    List<HomePlanTable> homePlanList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $homePlanTable WHERE catTableName = '$tableName'");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = HomePlanTable.fromJson(answer);
        homePlanList.add(homePlanData);
      }
    }
    return homePlanList.first;
  }

  Future<DiscoverPlanTable> getDiscoverPlanDataForHistory(int planId) async {
    List<DiscoverPlanTable> homePlanList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .rawQuery("SELECT * FROM $discoverPlanTable WHERE planId = $planId");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = DiscoverPlanTable.fromJson(answer);
        homePlanList.add(homePlanData);
      }
    }
    return homePlanList.first;
  }

  Future<List<ReminderTable>> getReminderData() async {
    List<ReminderTable> homePlanList = [];
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $reminderTable");
    if (maps.length > 0) {
      for (var answer in maps) {
        var homePlanData = ReminderTable.fromJson(answer);
        homePlanList.add(homePlanData);
      }
    }
    homePlanList.forEach((element) {
      Debug.printLog("id: " +
          element.id.toString() +
          "time: " +
          element.time! +
          "isActive: " +
          element.isActive!.toString());
    });
    return homePlanList;
  }

  Future<int> insertReminderData(ReminderTable reminderData) async {
    var dbClient = await db;
    var result = await dbClient.insert(reminderTable, reminderData.toJson());
    Debug.printLog("res: $result");
    return result;
  }

  Future<int?> updateReminderTime(int id, String time) async {
    var dbClient = await db;
    var result = await dbClient
        .rawUpdate(" UPDATE $reminderTable SET time = '$time' where id = $id ");
    Debug.printLog("res: $result");
    return result;
  }

  Future<int?> updateReminderDays(int id, String days, String repeatNo) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        " UPDATE $reminderTable SET days = '$days', repeatNo = '$repeatNo' where id = $id ");
    Debug.printLog("res: $result");
    return result;
  }

  Future<int?> updateReminderStatus(int id, String isActive) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        " UPDATE $reminderTable SET isActive = '$isActive' where id = $id ");
    Debug.printLog("res: $result");
    return result;
  }

  Future<int?> deleteReminder(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.delete(reminderTable, where: "id = ?", whereArgs: [id]);
    Debug.printLog("res: $result");
    return result;
  }
}
