import 'dart:convert';

class HomePlanTable {
  HomePlanTable({
    this.catId,
    this.catDefficultyLevel,
    this.catName,
    this.catSubCategory,
    this.catImage,
    this.catTableName,
  });


  int? catId;
  String? catName;
  int? catDefficultyLevel;
  String? catSubCategory;
  String? catImage;
  String? catTableName;

  factory HomePlanTable.fromRawJson(String str) =>
      HomePlanTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomePlanTable.fromJson(Map<String, dynamic> json) => HomePlanTable(
    catId: json["catId"],
    catDefficultyLevel: json["catDefficultyLevel"],
    catName: json["catName"],
    catSubCategory: json["catSubCategory"],
    catImage: json["catImage"],
    catTableName: json["catTableName"],
  );

  Map<String, dynamic> toJson() => {
    "catId": catId,
    "catDefficultyLevel": catDefficultyLevel,
    "catName": catName,
    "catSubCategory": catSubCategory,
    "catImage": catImage,
    "catTableName": catTableName,
  };
}
