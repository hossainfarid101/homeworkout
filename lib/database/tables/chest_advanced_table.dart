import 'dart:convert';

class ChestAdvancedTable{
  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? time;
  String? timeType;
  String? image;

  ChestAdvancedTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.time,
    this.timeType,
    this.image,
  });

  factory ChestAdvancedTable.fromRawJson(String str) =>
      ChestAdvancedTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChestAdvancedTable.fromJson(Map<String, dynamic> json) => ChestAdvancedTable(
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