import 'dart:convert';

class LegAdvancedTable {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? time;
  String? timeType;
  String? image;

  LegAdvancedTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.time,
    this.timeType,
    this.image,
  });

  factory LegAdvancedTable.fromRawJson(String str) =>
      LegAdvancedTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LegAdvancedTable.fromJson(Map<String, dynamic> json) =>
      LegAdvancedTable(
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
