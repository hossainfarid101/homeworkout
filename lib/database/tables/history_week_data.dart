import 'dart:convert';

import 'package:homeworkout_flutter/database/tables/history_table.dart';


class HistoryWeekData{

  HistoryWeekData({
    this.weekNumber,
    this.weekStart,
    this.weekEnd,
    this.totTime,
    this.totKcal,
    this.totWorkout,
    this.arrHistoryDetail,
  });


  String? weekNumber;
  String? weekStart;
  String? weekEnd;
  double? totTime;
  int? totKcal;
  int? totWorkout;
  List<HistoryTable>? arrHistoryDetail=[];


  factory HistoryWeekData.fromRawJson(String str) =>
      HistoryWeekData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryWeekData.fromJson(Map<String, dynamic> json) => HistoryWeekData(
      weekNumber: json["weekNumber"],
      weekStart: json["weekStart"],
      weekEnd: json["weekEnd"],
      totTime: json["totTime"],
      totKcal: json["totKcal"],
      totWorkout: json["totWorkout"],
      arrHistoryDetail: json["arrHistoryDetail"],
  );

  Map<String, dynamic> toJson() => {
    "weekNumber": weekNumber,
    "weekStart": weekStart,
    "weekEnd": weekEnd,
    "totTime": totTime,
    "totKcal": totKcal,
    "totWorkout": totWorkout,
    "arrHistoryDetail": arrHistoryDetail,
  };

}