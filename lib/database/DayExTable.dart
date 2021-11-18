import 'dart:convert';

class DayExTable {
  DayExTable({
      this.dayExId,
      this.sort,
      this.defaultSort,
      // this.exUnit,
      this.planId,
      this.dayId,
      this.exId,
      this.exTime,
      this.isCompleted,
      this.updatedExTime,
      this.replaceExId,
      this.isDeleted,
      });

  int? dayExId;
  int? sort;
  int? defaultSort;
  // String? exUnit;
  String? planId;
  String? dayId;
  String? exId;
  String? exTime;
  String? isCompleted;
  String? updatedExTime;
  String? replaceExId;
  String? isDeleted;

  factory DayExTable.fromRawJson(String str) =>
      DayExTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DayExTable.fromJson(Map<String, dynamic> json) => DayExTable(
      dayExId: json["dayExId"],
      sort: json["sort"],
      defaultSort: json["defaultSort"],
      // exUnit: json["exUnit"],
      planId: json["planId"],
      dayId: json["dayId"],
      exId: json["exId"],
      exTime: json["exTime"],
      isCompleted: json["isCompleted"],
      updatedExTime: json["updatedExTime"],
      replaceExId: json["replaceExId"],
      isDeleted: json["isDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "dayExId": dayExId,
    "sort": sort,
    "defaultSort": defaultSort,
    // "exUnit": exUnit,
    "planId": planId,
    "dayId": dayId,
    "exId": exId,
    "exTime": exTime,
    "isCompleted": isCompleted,
    "updatedExTime": updatedExTime,
    "replaceExId": replaceExId,
    "isDeleted": isDeleted,
  };
}
