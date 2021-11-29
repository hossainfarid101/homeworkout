import 'dart:convert';

import 'package:homeworkout_flutter/database/model/WeekDayData.dart';

class WeeklyDayData {
  WeeklyDayData({
    this.Workout_id,
    this.Day_name,
    this.Week_name,
    this.Is_completed,
    this.categoryName,
    this.arrWeekDayData,
  });

  int? Workout_id;
  String? Day_name;
  String? Week_name;
  String? Is_completed;
  String? categoryName;
  List<WeekDayData>? arrWeekDayData = [];
  bool isShow = false;

  factory WeeklyDayData.fromRawJson(String str) =>
      WeeklyDayData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyDayData.fromJson(Map<String, dynamic> json) => WeeklyDayData(
      Workout_id: json["Workout_id"],
      Day_name: json["Day_name"],
      Week_name: json["Week_name"],
      Is_completed: json["Is_completed"],
      categoryName: json["categoryName"],
      arrWeekDayData: json["arrWeekDayData"],
  );

  Map<String, dynamic> toJson() => {
    "Workout_id": Workout_id,
    "Day_name": Day_name,
    "Week_name": Week_name,
    "Is_completed": Is_completed,
    "categoryName": categoryName,
    "arrWeekDayData": arrWeekDayData,
  };
}
