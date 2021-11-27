import 'dart:convert';

class HomePlanTable {
  int? planId;
  String? planName;
  String? planText;
  String? planLvl;
  String? planImage;
  String? planType;
  String? planWorkouts;
  String? planMinutes;
  String? shortDes;
  bool? hasSubPlan;
  String? parentPlanId;
  String? discoverCatName;

  HomePlanTable({
    this.planId,
    this.planName,
    this.planText,
    this.planLvl,
    this.planImage,
    this.planType,
    this.planWorkouts,
    this.planMinutes,
    this.shortDes,
    this.hasSubPlan,
    this.parentPlanId,
    this.discoverCatName,
});

  factory HomePlanTable.fromRawJson(String str) =>
      HomePlanTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomePlanTable.fromJson(Map<String, dynamic> json) => HomePlanTable(
    planId: json["planId"],
    planName: json["planName"],
    planText: json["planText"],
    planLvl: json["Description"],
    planImage: json["planImage"],
    planType: json["planType"],
    planWorkouts: json["planWorkouts"],
    planMinutes: json["planMinutes"],
    shortDes: json["shortDes"],
    hasSubPlan: json["hasSubPlan"],
    parentPlanId: json["parentPlanId"],
    discoverCatName: json["discoverCatName"],

  );

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "planName": planName,
    "planText": planText,
    "Description": planLvl,
    "planImage": planImage,
    "planType": planType,
    "planWorkouts": planWorkouts,
    "planMinutes": planMinutes,
    "shortDes": shortDes,
    "hasSubPlan": hasSubPlan,
    "parentPlanId": parentPlanId,
    "discoverCatName": discoverCatName,
  };

}