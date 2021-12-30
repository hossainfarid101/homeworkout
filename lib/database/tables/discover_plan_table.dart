import 'dart:convert';

class DiscoverPlanTable {
  int? planId;
  String? planName;
  String? planText;
  String? planLvl;
  String? planImage;
  String? planImageSub;
  String? planType;
  String? planWorkouts;
  String? planMinutes;
  String? shortDes;
  String? hasSubPlan;
  String? parentPlanId;
  String? discoverCatName;
  String? introduction;

  DiscoverPlanTable({
    this.planId,
    this.planName,
    this.planText,
    this.planLvl,
    this.planImage,
    this.planImageSub,
    this.planType,
    this.planWorkouts,
    this.planMinutes,
    this.shortDes,
    this.hasSubPlan,
    this.parentPlanId,
    this.discoverCatName,
    this.introduction,
  });

  factory DiscoverPlanTable.fromRawJson(String str) =>
      DiscoverPlanTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DiscoverPlanTable.fromJson(Map<String, dynamic> json) =>
      DiscoverPlanTable(
        planId: json["planId"],
        planName: json["planName"],
        planText: json["planText"],
        planLvl: json["planLvl"],
        planImage: json["planImage"],
        planImageSub: json["planImageSub"],
        planType: json["planType"],
        planWorkouts: json["planWorkouts"],
        planMinutes: json["planMinutes"],
        shortDes: json["shortDes"],
        hasSubPlan: json["hasSubPlan"],
        parentPlanId: json["parentPlanId"],
        discoverCatName: json["discoverCatName"],
        introduction: json["introduction"],
      );

  Map<String, dynamic> toJson() => {
        "planId": planId,
        "planName": planName,
        "planText": planText,
        "planLvl": planLvl,
        "planImage": planImage,
        "planImageSub": planImageSub,
        "planType": planType,
        "planWorkouts": planWorkouts,
        "planMinutes": planMinutes,
        "shortDes": shortDes,
        "hasSubPlan": hasSubPlan,
        "parentPlanId": parentPlanId,
        "discoverCatName": discoverCatName,
        "introduction": introduction,
      };
}
