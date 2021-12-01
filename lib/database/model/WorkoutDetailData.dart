import 'dart:convert';

class WorkoutDetail {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? Time_beginner;
  String? timeType;
  String? level;
  String? image;

  WorkoutDetail({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.Time_beginner,
    this.timeType,
    this.level,
    this.image,
  });

  factory WorkoutDetail.fromRawJson(String str) =>
      WorkoutDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkoutDetail.fromJson(Map<String, dynamic> json) => WorkoutDetail(
    workoutId: json["Workout_id"],
    title: json["Title"],
    videoLink: json["videoLink"],
    description: json["Description"],
    Time_beginner: json["Time_beginner"],
    timeType: json["time_type"],
    image: json["Image"],

  );

  Map<String, dynamic> toJson() => {
    "Workout_id": workoutId,
    "Title": title,
    "videoLink": videoLink,
    "Description": description,
    "Time_beginner": Time_beginner,
    "time_type": timeType,
    "Image": image,
  };
}