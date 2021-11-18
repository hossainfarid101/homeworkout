import 'dart:async';
import 'dart:ffi';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/database/DayExTable.dart';
import 'package:homeworkout_flutter/database/ExerciseDataModel.dart';
import 'package:homeworkout_flutter/database/ExerciseTable.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'HistoryTable.dart';
import 'HistoryWeekData.dart';
import 'PlanDaysTable.dart';
import 'WeightTable.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = new DataBaseHelper.internal();

  // ignore: non_constant_identifier_names
  String planDaysTable = "PlanDaysTable";
  String dayExTable = "DayExTable";
  String exerciseTable = "ExerciseTable";
  String weightTable = "WeightTable";
  String historyTable = "HistoryTable";
  String historyWeekData = "HistoryWeekData";

  factory DataBaseHelper() => instance;

  Database? _db;

  DataBaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  init() async {
    // io.Directory applicationDirectory = await getApplicationDocumentsDirectory();

    var dbPath = await getDatabasesPath();
    Debug.printLog("getDatabasesPath ===>" + dbPath.toString());

    String dbPathEnliven = path.join(dbPath, "LoseWeightForMen.db");
    Debug.printLog("dbPathEnliven ===>" + dbPathEnliven.toString());

    bool dbExistsEnliven = await io.File(dbPathEnliven).exists();

    if (!dbExistsEnliven) {
      // Copy from asset
      ByteData data = await rootBundle
          .load(path.join("assets/database", "LoseWeightForMen.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await io.File(dbPathEnliven).writeAsBytes(bytes, flush: true);
    }

    return this._db = await openDatabase(dbPathEnliven);
  }



  Future<List<PlanDaysTable>> getPlanDaysList(String strPlanId) async {
    var dbClient = await db;
    List<PlanDaysTable> daysList = [];
    List<Map<String, dynamic>> res = await dbClient
        .rawQuery("SELECT * FROM $planDaysTable WHERE planId = '$strPlanId'");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = PlanDaysTable.fromJson(answer);
        daysList.add(daysData);
      }
    }
    return daysList;
  }

  Future<List<DayExTable>> getCompleteDayExList(int strDayId) async {
    var dbClient = await db;
    List<DayExTable> daysList = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "Select * From $dayExTable where dayId = $strDayId AND isCompleted = 1");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = DayExTable.fromJson(answer);
        daysList.add(daysData);
      }
    }
    return daysList;
  }

  Future<List<PlanDaysTable>> getCompleteDayCountByPlanId(String planId) async {
    var dbClient = await db;
    List<PlanDaysTable> daysList = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "Select * From $planDaysTable where planId = '$planId' AND isCompleted = 1");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = PlanDaysTable.fromJson(answer);
        daysList.add(daysData);
      }
    }
    return daysList;
  }

  Future<List<ExerciseDataModel>> getDayExList(String strDayId) async {
    var dbClient = await db;
    List<ExerciseDataModel> daysList = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "SELECT DX.sort, DX.defaultSort,DX.dayExId, DX.planId,DX.dayId, DX.isCompleted, CASE WHEN DX.updatedExTime != '' THEN DX.updatedExTime ELSE DX.exTime END as exTime,  CASE WHEN DX.replaceExId != '' THEN DX.replaceExId ELSE DX.exId END as exId, EX.exDescription, EX.exVideo,EX.exPath,EX.exName,Ex.exUnit FROM $dayExTable as DX INNER JOIN $exerciseTable as EX ON (CASE WHEN DX.replaceExId != '' THEN DX.replaceExId ELSE DX.exId END)= EX.exId WHERE DX.dayId = '$strDayId' and DX.isDeleted = '0' ");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = ExerciseDataModel.fromJson(answer);
        daysList.add(daysData);
      }
    }

    return daysList;
  }

  Future<List<ExerciseDataModel>> getAllExerciseForReplace() async {
    var dbClient = await db;
    List<ExerciseDataModel> daysList = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "SELECT DX.sort, DX.defaultSort, DX.dayExId, DX.planId, DX.dayId, DX.isCompleted, CASE WHEN DX.updatedExTime != '' THEN DX.updatedExTime ELSE DX.exTime END AS exTime, CASE WHEN DX.replaceExId != '' THEN DX.replaceExId ELSE DX.exId END AS exId,EX.exDescription, EX.exVideo, EX.exPath, EX.exName,  Ex.exUnit FROM DayExTable AS DX INNER JOIN ExerciseTable AS EX ON (CASE WHEN DX.replaceExId != '' THEN DX.replaceExId ELSE DX.exId END) = EX.exId group by exName");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = ExerciseDataModel.fromJson(answer);
        daysList.add(daysData);
      }
    }

    return daysList;
  }

  Future<List<ExerciseTable>> getAllExerciseList() async {
    var dbClient = await db;
    List<ExerciseTable> daysList = [];
    List<Map<String, dynamic>> res =
        await dbClient.rawQuery("Select * From $exerciseTable");
    if (res.length > 0) {
      for (var answer in res) {
        var daysData = ExerciseTable.fromJson(answer);
        daysList.add(daysData);
      }
    }
    return daysList;
  }

  //--------------------Weight table----------------------------------------

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
        "SELECT *, IFNULL(MAX(WeightKg),0), IFNULL(MAX(WeightLb),0) FROM $weightTable");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      //Debug.printLog("max weight: ${weightDataList.WeightKg}");
      return weightDataList;
    }
  }

  Future<WeightTable?> getMinWeight() async {
    var dbClient = await db;
    var weightDataList;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
        "SELECT *, IFNULL(MIN(WeightKg),0), IFNULL(MIN(WeightLb),0) FROM $weightTable");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      //Debug.printLog("min weight: ${weightDataList.WeightKg}");
      return weightDataList;
    }
  }

  Future<WeightTable?> getCurrentWeight(String? date) async {
    Debug.printLog("$date");
    var dbClient = await db;
    var weightDataList;
    //List<Map<String, dynamic>> result = await dbClient.rawQuery("SELECT *, IFNULL(MAX(WeightDate),0) FROM $weightTable ORDER BY WeightDate DESC LIMIT 1");
    List<Map<String, dynamic>> result = await dbClient
        .rawQuery("SELECT * FROM $weightTable WHERE WeightDate = '$date'");
    if (result.length > 0) {
      for (var answer in result) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList = weightData;
      }
      //Debug.printLog("current weight: ${weightDataList.WeightKg}");
      return weightDataList;
    }
  }

  Future<int?> updateWeight(
      {String? date, double? weightKG, double? weightLBS}) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        " UPDATE $weightTable SET WeightKg = $weightKG, WeightLb = $weightLBS where WeightDate = '$date' ");
    Debug.printLog("res: $result");
    return result;
  }

  //============Plan days table==================

  Future<int?> updateDayProgress(
      {String? dayProgress, int? dayId, String? planId}) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $planDaysTable SET dayProgress = '$dayProgress' where dayId = '$dayId' AND planId = '$planId' ");
    //Debug.printLog("res: $result");
    return result;
  }

  //=============History table=============

  Future<int>? insertHistoryData(HistoryTable historyData) async {
    var dbClient = await db;
    var result = await dbClient.insert(historyTable, historyData.toJson());
    Debug.printLog("res: $result");
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
    historyDataList.forEach((element) {
      Debug.printLog("History data ::: " + element.HDateTime.toString());
    });
    return historyDataList;
  }

  Future<int> deleteHistoryData(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      historyTable,
      where: "HId = ?",
      whereArgs: [id],
    );
  }

  Future<List<HistoryWeekData>> getHistoryWeekData() async {
    var dbClient = await db;
    List<HistoryWeekData> historyDataList = [];
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "select strftime('%W', HDateTime) as weekNumber, max(date(HDateTime, 'weekday 0' ,'-6 day')) as weekStart, max(date(HDateTime, 'weekday 0', '-0 day'))"
        " as weekEnd from $historyTable GROUP BY weekNumber");
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
        "SELECT sum(HBurnKcal) as HBurnKcalTotal from $historyTable WHERE date('$strWeekStart') <= date(HDateTime) AND date('$strWeekEnd') >= date(HDateTime)");
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
        "SELECT sum(CAST(HDuration AS DOUBLE)) as HDuration from $historyTable WHERE date('$strWeekStart') <= date(HDateTime) AND date('$strWeekEnd') >= date(HDateTime)");
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
        "SELECT * FROM $historyTable WHERE date('$strWeekStart') <= date(HDateTime) AND date('$strWeekEnd') >= date(HDateTime) Order by HId Desc");
    if (res.length > 0) {
      for (var answer in res) {
        var waterData = HistoryTable.fromJson(answer);
        historyData.add(waterData);
      }
    }
    return historyData;
  }

  Future<PlanDaysTable?> getPlanDaysTableById(
      String planId, String dayName) async {
    var dbClient = await db;
    List<PlanDaysTable> historyData = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "select * from PlanDaysTable where planId='$planId' and dayName ='$dayName'");
    if (res.length > 0) {
      for (var answer in res) {
        var waterData = PlanDaysTable.fromJson(answer);
        historyData.add(waterData);
      }
    }
    return historyData.first;
  }

  Future<int?> getHistoryTotalWorkout() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(HTotalEx as INTEGER)) as totWorkout FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<int?> getHistoryTotalMinutes() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(HDuration as INTEGER)) as HDuration FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<double?> getHistoryTotalKCal() async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT SUM(CAST(HBurnKcal as Float)) as HBurnKcal FROM $historyTable");
    if (res.length > 0) {
      return res.first.values.first;
    } else {
      return 0.0;
    }
  }

  Future<bool?> isHistoryAvailableDateWise(String date) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT HId FROM $historyTable WHERE DateTime(strftime('%Y-%m-%d', DateTime(HDateTime) ) ) = DateTime(strftime('%Y-%m-%d', DateTime('$date')))");
    if (res.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  /*Future<List<HistoryTable>> isHistoryAvailableCurrentWeek() async {
    var dbClient = await db;
    List<HistoryTable> historyData = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE (DATE(HDateTime) >= DATE('now','weekday 1','-7 days'))");

    if (res.length > 0) {
      for (var answer in res) {
        var waterData = HistoryTable.fromJson(answer);
        historyData.add(waterData);
      }
    }
    return historyData;
  }*/


  Future<int> updateDayWiseExercise(int dayId) async {
    Map<String, dynamic> row = {
      'isCompleted': "1",
    };
    var dbClient = await db;
    var result = await dbClient
        .update(planDaysTable, row, where: 'dayId = ?', whereArgs: [dayId]);
    Debug.printLog("res:updateDayWiseExercise ::::::  $result");
    return result;
  }

  Future<int> updateExerciseWise(int? dayExId) async {
    Map<String, dynamic> row = {
      'isCompleted': "1",
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'dayExId = ?', whereArgs: [dayExId]);
    Debug.printLog("res:updateExerciseWise ::::::  $result");
    return result;
  }

  Future<int> updateExerciseWiseToZero(int? dayExId) async {
    Map<String, dynamic> row = {
      'isCompleted': "0",
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'dayExId = ?', whereArgs: [dayExId]);
    Debug.printLog("res:updateExerciseWise ::::::  $result");
    return result;
  }

  Future<int> restartPlanByPlanId(String? planId) async {
    Map<String, dynamic> row = {
      'isCompleted': "0",
    };
    var dbClient = await db;
    var result = await dbClient
        .update(planDaysTable, row, where: 'planId = ?', whereArgs: [planId]).then((value) async => await dbClient
        .update(dayExTable, row, where: 'planId = ?', whereArgs: [planId]));
    Debug.printLog("res:restartPlanByPlanId ::::::  $result");
    return result;
  }

  Future<int> reorderExercise(String? planId,String? dayId,int dayExId,int sortValue) async {
    Map<String, dynamic> row = {
      'sort': sortValue,
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'planId = ? and dayId = ? and dayExId = ?', whereArgs: [planId,dayId,dayExId]);
    //Debug.printLog("res:reorderExercise ::::::::  $result  $sortValue");
    return result;
  }

  Future<int> replaceExercise(int dayExId,String replaceExId) async {
    Map<String, dynamic> row = {
      'replaceExId': '$replaceExId',
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'dayExId = ?', whereArgs: [dayExId]);
    Debug.printLog("res:replaceExercise ::::::::  $result ");
    return result;
  }

  Future<int> resetExercise(String? planId,String? dayId,int dayExId,int sortValue) async {
    Map<String, dynamic> row = {
      'sort': sortValue,
      'updatedExTime': "",
      'isDeleted': '0',
      'replaceExId': null
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'planId = ? and dayId = ? and dayExId = ?', whereArgs: [planId,dayId,dayExId]);
    Debug.printLog("res:resetExercise ::::::::  $result  $sortValue");
    return result;
  }

  Future<int> resetExerciseDelete(String? planId,String? dayId,int dayExId,int sortValue) async {
    Map<String, dynamic> row = {
      'sort': sortValue,
      'isDeleted': '0',
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'planId = ? and dayId = ? and dayExId = ?', whereArgs: [planId,dayId,dayExId]);
    Debug.printLog("res:resetExercise ::::::::  $result  $sortValue");
    return result;
  }



  Future<int> updateDurationExerciseWise(int dayExId,int duration) async {
    Map<String, dynamic> row = {
      'updatedExTime': '$duration',
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'dayExId = ?', whereArgs: [dayExId]);
    //Debug.printLog("res:updateDurationExerciseWise ::::::::  $result  ");
    return result;
  }

  Future<int> deleteExercise(int dayExId) async {
    Map<String, dynamic> row = {
      'isDeleted': '1',
    };
    var dbClient = await db;
    var result = await dbClient
        .update(dayExTable, row, where: 'dayExId = ?', whereArgs: [dayExId]);
    Debug.printLog("res:deleteExercise ::::::::  $result  ");
    return result;
  }


  Future<int> restartProgress() async {
    Map<String, dynamic> row = {
      'isCompleted': "0",
    };
    var dbClient = await db;
    await dbClient.update(dayExTable, row, where: null, whereArgs: null);
    await dbClient.update(planDaysTable, row, where: null, whereArgs: null);
    await dbClient.delete(historyTable,where: null,whereArgs: null);
    var result = await dbClient.delete(weightTable,where: null,whereArgs: null);
    return result;
  }

  Future<int> restartDayPlan(String planId) async {
    Map<String, dynamic> row = {
      'isCompleted': "0",
    };
    var dbClient = await db;
    await dbClient.update(dayExTable, row, where: 'planId = ?', whereArgs: [planId]);
    var result = await dbClient.update(planDaysTable, row, where: 'planId = ?', whereArgs: [planId]);
    return result;
  }

  Future<int> reStartPlanDay(String strDayId) async {
    Map<String, dynamic> row = {
      'isCompleted': "0",
      'updatedExTime': "",
    };
    var dbClient = await db;
    var result = await dbClient.update(dayExTable, row, where: 'dayId = ?', whereArgs: [strDayId]);
    return result;
  }

  Future<int?> updateTotalTimeOfPlanDay(int dayId, int totalTime) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $planDaysTable SET totalTime = $totalTime where dayId = $dayId");
    Debug.printLog("res:planDaysTable :::  $result");
    return result;
  }


}
