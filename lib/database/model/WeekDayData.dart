import 'dart:convert';

class WeekDayData {
  WeekDayData({
    this.dayName,
    this.isCompleted,
  });

  String? dayName;
  String? isCompleted;

  factory WeekDayData.fromRawJson(String str) =>
      WeekDayData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeekDayData.fromJson(Map<String, dynamic> json) => WeekDayData(
        dayName: json["Day_name"],
        isCompleted: json["Is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "Day_name": dayName,
        "Is_completed": isCompleted,
      };
}
