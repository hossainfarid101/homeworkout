import 'dart:convert';

class DiscoverSingleExerciseData {
  DiscoverSingleExerciseData({
    this.PlanId,
    this.IsCompleted,
    this.ExTime,
    this.ExId,
    this.exDescription,
    this.exVideo,
    this.exPath,
    this.exName,
    this.exUnit,
  });

  String? PlanId;
  String? IsCompleted;
  String? ExTime;
  String? ExId;
  String? exDescription;
  String? exVideo;
  String? exPath;
  String? exName;
  String? exUnit;

  factory DiscoverSingleExerciseData.fromRawJson(String str) =>
      DiscoverSingleExerciseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscoverSingleExerciseData.fromJson(Map<String, dynamic> json) => DiscoverSingleExerciseData(
    PlanId: json["PlanId"],
    IsCompleted: json["IsCompleted"],
    ExTime: json["ExTime"],
    ExId: json["ExId"],
    exDescription: json["exDescription"],
    exVideo: json["exVideo"],
    exPath: json["exPath"],
    exName: json["exName"],
    exUnit: json["exUnit"],
  );

  Map<String, dynamic> toJson() => {
    "PlanId": PlanId,
    "IsCompleted": IsCompleted,
    "ExTime": ExTime,
    "ExId": ExId,
    "exDescription": exDescription,
    "exVideo": exVideo,
    "exPath": exPath,
    "exName": exName,
    "exUnit": exUnit,
  };
}
