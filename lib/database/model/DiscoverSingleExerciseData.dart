import 'dart:convert';

class DiscoverSingleExerciseData {
  DiscoverSingleExerciseData({
    this.planId,
    this.isCompleted,
    this.exTime,
    this.exId,
    this.exDescription,
    this.exVideo,
    this.exPath,
    this.exName,
    this.exUnit,
  });

  String? planId;
  String? isCompleted;
  String? exTime;
  String? exId;
  String? exDescription;
  String? exVideo;
  String? exPath;
  String? exName;
  String? exUnit;

  factory DiscoverSingleExerciseData.fromRawJson(String str) =>
      DiscoverSingleExerciseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscoverSingleExerciseData.fromJson(Map<String, dynamic> json) => DiscoverSingleExerciseData(
    planId: json["PlanId"],
    isCompleted: json["IsCompleted"],
    exTime: json["ExTime"],
    exId: json["ExId"],
    exDescription: json["exDescription"],
    exVideo: json["exVideo"],
    exPath: json["exPath"],
    exName: json["exName"],
    exUnit: json["exUnit"],
  );

  Map<String, dynamic> toJson() => {
    "PlanId": planId,
    "IsCompleted": isCompleted,
    "ExTime": exTime,
    "ExId": exId,
    "exDescription": exDescription,
    "exVideo": exVideo,
    "exPath": exPath,
    "exName": exName,
    "exUnit": exUnit,
  };
}
