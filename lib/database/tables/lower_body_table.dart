import 'dart:convert';

class LowerBodyTable {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? timeType;
  String? timeBeginner;
  String? timeIntermediate;
  String? timeAdvanced;
  String? dayName;
  String? weekName;
  String? level;
  String? isCompleted;
  String? image;

  LowerBodyTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.timeType,
    this.timeBeginner,
    this.timeAdvanced,
    this.timeIntermediate,
    this.dayName,
    this.weekName,
    this.level,
    this.isCompleted,
    this.image,
  });

  factory LowerBodyTable.fromRawJson(String str) =>
      LowerBodyTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LowerBodyTable.fromJson(Map<String, dynamic> json) => LowerBodyTable(
    workoutId: json["Workout_id"],
    title: json["Title"],
    videoLink: json["videoLink"],
    description: json["Description"],
    timeType: json["time_type"],
    image: json["Image"],
    timeBeginner: json["Time_beginner"],
    timeAdvanced: json["Time_advanced"],
    timeIntermediate: json["Time_intermidiate"],
    level: json["Level"],
    isCompleted: json["Is_completed"],
    weekName: json["Week_name"],
    dayName: json["Day_name"],

  );

  Map<String, dynamic> toJson() => {
    "Workout_id": workoutId,
    "Title": title,
    "videoLink": videoLink,
    "Description": description,
    "time_type": timeType,
    "Image": image,
    "Time_beginner": timeBeginner,
    "Time_advanced": timeAdvanced,
    "Time_intermidiate": timeIntermediate,
    "Level": level,
    "Is_completed": isCompleted,
    "Week_name": weekName,
    "Day_name": dayName,
  };
}