import 'dart:convert';

class WorkoutDetail {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? timeBeginner;
  String? timeType;
  String? level;
  String? image;
  int? sort;
  int? defaultSort;

  WorkoutDetail({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.timeBeginner,
    this.timeType,
    this.level,
    this.image,
    this.sort,
    this.defaultSort,
  });

  factory WorkoutDetail.fromRawJson(String str) =>
      WorkoutDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkoutDetail.fromJson(Map<String, dynamic> json) => WorkoutDetail(
        workoutId: json["Workout_id"],
        title: json["Title"],
        videoLink: json["videoLink"],
        description: json["Description"],
        timeBeginner: json["Time_beginner"],
        timeType: json["time_type"],
        image: json["Image"],
        sort: json["sort"],
        defaultSort: json["defaultSort"],
      );

  Map<String, dynamic> toJson() => {
        "Workout_id": workoutId,
        "Title": title,
        "videoLink": videoLink,
        "Description": description,
        "Time_beginner": timeBeginner,
        "time_type": timeType,
        "Image": image,
        "sort": sort,
        "defaultSort": defaultSort,
      };
}
