import 'package:flutter/services.dart';
import 'package:homeworkout_flutter/utils/debug.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

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

    String dbPathHomeWorkout = path.join(dbPath, "HomeWorkout.db");
    Debug.printLog("dbPathEnliven ===>" + dbPathHomeWorkout.toString());

    bool dbExistsEnliven = await io.File(dbPathHomeWorkout).exists();

    if (!dbExistsEnliven) {
      ByteData data = await rootBundle
          .load(path.join("assets/database", "HomeWorkout.db"));
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

  String historyTable ="tbl_history";
  String weightTable = "tbl_Weight";
  String youtubeLinkTable = "tbl_youtube_link";
  String reminderTable = "tbl_reminder";


}