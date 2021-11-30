import 'dart:convert';

class DiscoverExSingleTable {
  DiscoverExSingleTable({
      this.Id,
      this.PlanId,
      this.ExId,
      this.ExTime,
      this.IsCompleted,
      });

  int? Id;
  String? PlanId;
  String? ExId;
  String? ExTime;
  String? IsCompleted;

  factory DiscoverExSingleTable.fromRawJson(String str) =>
      DiscoverExSingleTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscoverExSingleTable.fromJson(Map<String, dynamic> json) => DiscoverExSingleTable(
      Id: json["Id"],
      PlanId: json["PlanId"],
      ExId: json["ExId"],
      ExTime: json["ExTime"],
      IsCompleted: json["IsCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "Id": Id,
    "PlanId": PlanId,
    "ExId": ExId,
    "ExTime": ExTime,
    "IsCompleted": IsCompleted,
  };
}
