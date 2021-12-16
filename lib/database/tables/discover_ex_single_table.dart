import 'dart:convert';

class DiscoverExSingleTable {
  DiscoverExSingleTable({
      this.id,
      this.planId,
      this.exId,
      this.exTime,
      this.isCompleted,
      });

  int? id;
  String? planId;
  String? exId;
  String? exTime;
  String? isCompleted;

  factory DiscoverExSingleTable.fromRawJson(String str) =>
      DiscoverExSingleTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscoverExSingleTable.fromJson(Map<String, dynamic> json) => DiscoverExSingleTable(
      id: json["Id"],
      planId: json["PlanId"],
      exId: json["ExId"],
      exTime: json["ExTime"],
      isCompleted: json["IsCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "PlanId": planId,
    "ExId": exId,
    "ExTime": exTime,
    "IsCompleted": isCompleted,
  };
}
