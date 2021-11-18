import 'dart:convert';

class ExerciseTable {
  ExerciseTable({
    this.exId,
    this.exName,
    this.exUnit,
    this.exPath,
    this.exDescription,
    this.exVideo,
    this.replaceTime,
    this.isInMyTraining,
    this.exerciseTime,
  });

  int? exId;
  String? exName;
  String? exUnit;
  String? exPath;
  String? exDescription;
  String? exVideo;
  String? replaceTime;
  String? exerciseTime;
  bool? isInMyTraining;

  factory ExerciseTable.fromRawJson(String str) =>
      ExerciseTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExerciseTable.fromJson(Map<String, dynamic> json) => ExerciseTable(
        exId: json["exId"],
        exName: json["exName"],
        exUnit: json["exUnit"],
        exPath: json["exPath"],
        exDescription: json["exDescription"],
        exVideo: json["exVideo"],
        replaceTime: json["replaceTime"],
        isInMyTraining: json["isInMyTraining"],
        exerciseTime: json["exerciseTime"],
      );

  Map<String, dynamic> toJson() => {
        "exId": exId,
        "exName": exName,
        "exUnit": exUnit,
        "exPath": exPath,
        "exDescription": exDescription,
        "exVideo": exVideo,
        "replaceTime": replaceTime,
        "isInMyTraining": isInMyTraining,
        "exerciseTime": exerciseTime,
      };
}
