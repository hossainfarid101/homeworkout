import 'dart:convert';

class ReminderTable {
  int? id;
  String? isActive;
  String? time;
  String? days;
  String? repeatNo;

  ReminderTable({
    this.id,
    this.time,
    this.days,
    this.isActive,
    this.repeatNo,
  });

  factory ReminderTable.fromRawJson(String str) =>
      ReminderTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderTable.fromJson(Map<String, dynamic> json) => ReminderTable(
      id: json["id"],
      time: json["time"],
      days: json["days"],
      isActive: json["isActive"],
      repeatNo: json["repeatNo"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "time": time,
        "days": days,
        "isActive": isActive,
        "repeatNo": repeatNo
      };
}
