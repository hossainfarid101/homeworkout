import 'dart:convert';

class ArmAdvancedTable {
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? time;
  String? timeType;
  String? image;

  ArmAdvancedTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.time,
    this.timeType,
    this.image,
  });

  factory ArmAdvancedTable.fromRawJson(String str) =>
      ArmAdvancedTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ArmAdvancedTable.fromJson(Map<String, dynamic> json) =>
      ArmAdvancedTable(
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
