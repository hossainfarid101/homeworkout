import 'dart:convert';

import 'dart:ffi';

class WeightTable{

  WeightTable({
    this.CurrentTimeStamp,
    this.WeightDate,
    this.WeightId,
    this.WeightKg,
    this.WeightLb
  });
  int? WeightId;
  double? WeightKg;
  double? WeightLb;
  String? WeightDate;
  String? CurrentTimeStamp;

  factory WeightTable.fromRawJson(String str) =>
      WeightTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightTable.fromJson(Map<String, dynamic> json) => WeightTable(
      WeightId: json["WeightId"],
      WeightKg: json["WeightKg"],
      WeightLb: json["WeightLb"],
      WeightDate: json["WeightDate"],
      CurrentTimeStamp: json["CurrentTimeStamp"],
  );

  Map<String, dynamic> toJson() => {
    "WeightId": WeightId,
    "WeightKg": WeightKg,
    "WeightLb": WeightLb,
    "WeightDate": WeightDate,
    "CurrentTimeStamp": CurrentTimeStamp,
  };


}