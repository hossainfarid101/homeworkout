import 'dart:convert';

class HistoryTable {
  int? id;
  int? planId;
  String? fromPage;
  String? tableName;
  String? planName;
  String? duration;
  String? dateTime;
  String? completionTime;
  String? burnKcal;
  String? totalWorkout;
  String? kg;
  String? cm;
  String? feelRate;
  String? dayName;
  String? weekName;

  HistoryTable({
    this.id,
    this.planId,
    this.fromPage,
    this.tableName,
    this.duration,
    this.planName,
    this.dateTime,
    this.completionTime,
    this.burnKcal,
    this.kg,
    this.totalWorkout,
    this.cm,
    this.feelRate,
    this.dayName,
    this.weekName,
  });

  factory HistoryTable.fromRawJson(String str) =>
      HistoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryTable.fromJson(Map<String, dynamic> json) => HistoryTable(
        id: json["Id"],
        planId: json["planId"],
        fromPage: json["fromPage"],
        tableName: json["tableName"],
        duration: json["duration"],
        planName: json["PlanName"],
        dateTime: json["DateTime"],
        completionTime: json["CompletionTime"],
        burnKcal: json["BurnKcal"],
        kg: json["Kg"],
        totalWorkout: json["TotalWorkout"],
        cm: json["Cm"],
        feelRate: json["FeelRate"],
        dayName: json["Day_name"],
        weekName: json["Week_name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "planId": planId,
        "fromPage": fromPage,
        "tableName": tableName,
        "PlanName": planName,
        "duration": duration,
        "DateTime": dateTime,
        "CompletionTime": completionTime,
        "BurnKcal": burnKcal,
        "Kg": kg,
        "TotalWorkout": totalWorkout,
        "Cm": cm,
        "FeelRate": feelRate,
        "Day_name": dayName,
        "Week_name": weekName,
      };
}
