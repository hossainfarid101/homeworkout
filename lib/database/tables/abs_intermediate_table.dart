import 'dart:convert';

class AbsIntermediateTable {

  int? workoutId;
  String? title;
  String? videoLink;
  String? description;
  String? time;
  String? timeType;
  String? image;

  AbsIntermediateTable({
    this.workoutId,
    this.title,
    this.videoLink,
    this.description,
    this.time,
    this.timeType,
    this.image,
  });

  factory AbsIntermediateTable.fromRawJson(String str) =>
      AbsIntermediateTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AbsIntermediateTable.fromJson(Map<String, dynamic> json) => AbsIntermediateTable(
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