import 'dart:convert';

class HistoryTable {
  HistoryTable({
    this.HId,
    this.HPlanName,
    this.HLvlName,
    this.HDayName,
    this.HBurnKcal,
    this.HDuration,
    this.HTotalEx,
    this.HKg,
    this.HCm,
    this.HFeelRate,
    this.HCompletionTime,
    this.HCompletionDate,
    this.HDateTime,
    this.HPlanId,
    this.HDayId,
  });

  int? HId;
  String? HPlanName;
  String? HLvlName;
  String? HDayName;
  String? HBurnKcal;
  String? HDuration;
  String? HTotalEx;
  String? HKg;
  String? HCm;
  String? HFeelRate;
  String? HCompletionTime;
  String? HCompletionDate;
  String? HDateTime;
  String? HDayId;
  String? HPlanId;


  factory HistoryTable.fromRawJson(String str) =>
      HistoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryTable.fromJson(Map<String, dynamic> json) => HistoryTable(
        HId: json["HId"],
        HPlanName: json["HPlanName"],
        HLvlName: json["HLvlName"],
        HDayName: json["HDayName"],
        HBurnKcal: json["HBurnKcal"],
        HTotalEx: json["HTotalEx"],
        HDuration: json["HDuration"],
        HKg: json["HKg"],
        HCm: json["HCm"],
        HFeelRate: json["HFeelRate"],
        HCompletionTime: json["HCompletionTime"],
        HCompletionDate: json["HCompletionDate"],
        HDateTime: json["HDateTime"],
        HPlanId: json["HPlanId"],
        HDayId: json["HDayId,"],
      );

  Map<String, dynamic> toJson() => {
        "HId": HId,
        "HPlanName": HPlanName,
        "HLvlName": HLvlName,
        "HDayName": HDayName,
        "HBurnKcal": HBurnKcal,
        "HTotalEx": HTotalEx,
        "HDuration": HDuration,
        "HKg": HKg,
        "HCm": HCm,
        "HFeelRate": HFeelRate,
        "HCompletionTime": HCompletionTime,
        "HCompletionDate": HCompletionDate,
        "HDateTime": HDateTime,
        "HPlanId": HPlanId,
        "HDayId": HDayId,
      };
}
