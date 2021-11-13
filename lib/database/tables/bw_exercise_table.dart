import 'dart:convert';

class BwExerciseTable {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? time;
  String? timeType;
  String? level;
  String? image;

  BwExerciseTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.time,
    this.timeType,
    this.level,
    this.image,
  });

  factory BwExerciseTable.fromRawJson(String str) =>
      BwExerciseTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BwExerciseTable.fromJson(Map<String, dynamic> json) => BwExerciseTable(
    workoutId: json["Workout_id"],
    title: json["Title"],
    videoLink: json["videoLink"],
    description: json["Description"],
    time: json["Time"],
    timeType: json["time_type"],
    image: json["Image"],

  );

  Map<String, dynamic> toJson() => {
    "Workout_id": workoutId,
    "Title": title,
    "videoLink": videoLink,
    "Description": description,
    "Time": time,
    "time_type": timeType,
    "Image": image,
  };
}