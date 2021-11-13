import 'dart:convert';

class ReminderTable {
  int? id;
  String? time;
  String? days;
  String? isActive;

  ReminderTable({
    this.time,
    this.days,
    this.id,
    this.isActive
  });

  factory ReminderTable.fromRawJson(String str) =>
      ReminderTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderTable.fromJson(Map<String, dynamic> json) => ReminderTable(
    id: json["Id"],
    isActive: json["IsActive"],
    days: json["Days"],
    time: json["Time"],


  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "IsActive": isActive,
    "Days": days,
    "Time": time,

  };
}