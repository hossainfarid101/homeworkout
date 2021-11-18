import 'dart:convert';

class ReminderData{
  ReminderData({
  this.id,
  this.isReminderOn,
  this.reminderTime,
  this.repeatDays,
  this.repeatNo,
  this.date_time
  });

  int? id;
  int? isReminderOn;
  String? reminderTime;
  String? repeatDays;
  String? repeatNo;
  String? date_time;

  factory ReminderData.fromRawJson(String str) =>
      ReminderData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderData.fromJson(Map<String, dynamic> json) => ReminderData(
      id: json["id"],
      isReminderOn: json["isReminderOn"],
      reminderTime: json["reminderTime"],
      repeatDays: json["repeatDays"],
      repeatNo: json["repeatNo"],
      date_time: json["date_time"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isReminderOn": isReminderOn,
    "reminderTime": reminderTime,
    "repeatDays": repeatDays,
    "repeatNo": repeatNo,
    "date_time": date_time
  };
}