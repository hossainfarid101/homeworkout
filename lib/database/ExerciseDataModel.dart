import 'dart:convert';

class ExerciseDataModel{
  ExerciseDataModel({
    this.dayExId,
    this.planId,
    this.dayId,
    this.exId,
    this.exTime,
    this.isCompleted,
    this.updatedExTime,
    this.replaceExId,
    this.exName,
    this.exUnit,
    this.exPath,
    this.exDescription,
    this.exVideo,
    this.sort,
    this.defaultSort,
  });

  int? dayExId;
  int? sort;
  int? defaultSort;
  String? planId;
  String? dayId;
  String? exId;
  String? exTime;
  String? isCompleted;
  String? updatedExTime;
  String? replaceExId;
  String? exName;
  String? exUnit;
  String? exPath;
  String? exDescription;
  String? exVideo;

  factory ExerciseDataModel.fromRawJson(String str) =>
      ExerciseDataModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExerciseDataModel.fromJson(Map<String, dynamic> json) => ExerciseDataModel(
    dayExId: json["dayExId"],
    planId: json["planId"],
    dayId: json["dayId"],
    exId: json["exId"],
    exTime: json["exTime"],
    isCompleted: json["isCompleted"],
    updatedExTime: json["updatedExTime"],
    replaceExId: json["replaceExId"],
    exName: json["exName"],
    exUnit: json["exUnit"],
    exPath: json["exPath"],
    exDescription: json["exDescription"],
    exVideo: json["exVideo"],
    sort: json["sort"],
    defaultSort: json["defaultSort"],

  );

  Map<String, dynamic> toJson() => {
    "dayExId": dayExId,
    "planId": planId,
    "dayId": dayId,
    "exId": exId,
    "exTime": exTime,
    "isCompleted": isCompleted,
    "updatedExTime": updatedExTime,
    "replaceExId": replaceExId,
    "exName": exName,
    "exUnit": exUnit,
    "exPath": exPath,
    "exDescription": exDescription,
    "exVideo": exVideo,
    "sort": sort,
    "defaultSort": defaultSort,
  };
}