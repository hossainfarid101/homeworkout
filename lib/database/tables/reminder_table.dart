import 'dart:convert';

class ReminderTable {
  int? id;
  String? isActive;
  String? time;
  String? days;

  ReminderTable({
    this.id,
    this.time,
    this.days,
    this.isActive,
  });

  factory ReminderTable.fromRawJson(String str) =>
      ReminderTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderTable.fromJson(Map<String, dynamic> json) => ReminderTable(
    id: json["id"],
    time: json["time"],
    days: json["days"],
    isActive: json["isActive"],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "days": days,
    "isActive": isActive,
  };
}