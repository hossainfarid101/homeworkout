import 'dart:convert';

class WeekDayData {
  WeekDayData({
    this.Day_name,
    this.Is_completed,
  });

  String? Day_name;
  String? Is_completed;

  factory WeekDayData.fromRawJson(String str) =>
      WeekDayData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeekDayData.fromJson(Map<String, dynamic> json) => WeekDayData(
    Day_name: json["Day_name"],
    Is_completed: json["Is_completed"],
  );

  Map<String, dynamic> toJson() => {
    "Day_name": Day_name,
    "Is_completed": Is_completed,
  };
}
