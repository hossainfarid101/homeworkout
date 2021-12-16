import 'dart:convert';

import 'package:homeworkout_flutter/database/model/WeekDayData.dart';

class WeeklyDayData {
  WeeklyDayData({
    this.workoutId,
    this.dayName,
    this.weekName,
    this.isCompleted,
    this.categoryName,
    this.arrWeekDayData,
  });

  int? workoutId;
  String? dayName;
  String? weekName;
  String? isCompleted;
  String? categoryName;
  List<WeekDayData>? arrWeekDayData = [];
  bool isShow = false;

  factory WeeklyDayData.fromRawJson(String str) =>
      WeeklyDayData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeeklyDayData.fromJson(Map<String, dynamic> json) => WeeklyDayData(
      workoutId: json["Workout_id"],
      dayName: json["Day_name"],
      weekName: json["Week_name"],
      isCompleted: json["Is_completed"],
      categoryName: json["categoryName"],
      arrWeekDayData: json["arrWeekDayData"],
  );

  Map<String, dynamic> toJson() => {
    "Workout_id": workoutId,
    "Day_name": dayName,
    "Week_name": weekName,
    "Is_completed": isCompleted,
    "categoryName": categoryName,
    "arrWeekDayData": arrWeekDayData,
  };
}
