import 'dart:convert';

class WeightTable {
  int? id;
  double? weightKG;
  double? weightLB;
  String? date;
  String? currentTimeStamp;

  WeightTable({
    this.id,
    this.date,
    this.currentTimeStamp,
    this.weightKG,
    this.weightLB
  });

  factory WeightTable.fromRawJson(String str) =>
      WeightTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightTable.fromJson(Map<String, dynamic> json) => WeightTable(
    id: json["Id"],
    date: json["Date"],
    currentTimeStamp: json["CurrentDate"],
    weightKG: json["WeightKG"],
    weightLB: json["WeightLB"],


  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Date": date,
    "CurrentDate": currentTimeStamp,
    "WeightKG": weightKG,
    "WeightLB": weightLB,

  };
}