import 'dart:convert';

class PlanDaysTable {
  PlanDaysTable({
      this.planId,
      this.dayId,
      this.dayName,
      this.isCompleted,
      this.dayProgress,
      this.totalTime
  });

  int? dayId;
  String? planId;
  String? dayName;
  String? isCompleted;
  String? dayProgress;
  int? totalTime;

  factory PlanDaysTable.fromRawJson(String str) =>
      PlanDaysTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanDaysTable.fromJson(Map<String, dynamic> json) => PlanDaysTable(
      planId: json["planId"],
      dayId: json["dayId"],
      dayName: json["dayName"],
      isCompleted: json["isCompleted"],
      dayProgress: json["dayProgress"],
      totalTime: json["totalTime"],
  );

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "dayId": dayId,
    "dayName": dayName,
    "isCompleted": isCompleted,
    "dayProgress": dayProgress,
    "totalTime": totalTime,
  };
}
