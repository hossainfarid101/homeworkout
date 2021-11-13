import 'dart:convert';

class YoutubeLinkTable {
  int? id;
  String? youtubeLink;
  String? title;

  YoutubeLinkTable({
    this.id,
    this.title,
    this.youtubeLink,
  });

  factory YoutubeLinkTable.fromRawJson(String str) =>
      YoutubeLinkTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory YoutubeLinkTable.fromJson(Map<String, dynamic> json) => YoutubeLinkTable(
    id: json["id"],
    title: json["Title"],
    youtubeLink: json["youtube_link"]


  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "id": id,
    "youtube_link": youtubeLink

  };

}