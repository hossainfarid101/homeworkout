import 'dart:convert';

class HistoryTable {
  int? id;
  String? levelName;
  String? planName;
  String? dateTime;
  String? completionTime;
  String? burnKcal;
  String? totalWorkout;
  String? kg;
  String? feet;
  String? inch;
  String? feelRate;
  String? dayName;
  String? weekName;

  HistoryTable({
    this.id,
    this.levelName,
    this.planName,
    this.dateTime,
    this.completionTime,
    this.burnKcal,
    this.kg,
    this.totalWorkout,
    this.feet,
    this.inch,
    this.feelRate,
    this.dayName,
    this.weekName,
  });

  factory HistoryTable.fromRawJson(String str) =>
      HistoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryTable.fromJson(Map<String, dynamic> json) => HistoryTable(
      id: json["Id"],
      levelName: json["LevelName"],
      planName: json["PlanName"],
      dateTime: json["DateTime"],
      completionTime: json["CompletionTime"],
      burnKcal: json["BurnKcal"],
      kg: json["Kg"],
      totalWorkout: json["TotalWorkout"],
      feet: json["Feet"],
      inch: json["Inch"],
      feelRate: json["FeelRate"],
      dayName: json["Day_name"],
      weekName: json["Week_name"],

  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "LevelName": levelName,
    "PlanName": planName,
    "DateTime": dateTime,
    "CompletionTime": completionTime,
    "BurnKcal": burnKcal,
    "Kg": kg,
    "TotalWorkout": totalWorkout,
    "Feet": feet,
    "Inch": inch,
    "FeelRate": feelRate,
    "Day_name": dayName,
    "Week_name": weekName,
  };
}