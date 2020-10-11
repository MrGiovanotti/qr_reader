import 'dart:convert';

Scan scanFromJson(String str) => Scan.fromJson(json.decode(str));

String scanToJson(Scan data) => json.encode(data.toJson());

class Scan {
  Scan({
    this.id,
    this.value,
  });

  int id;
  String value;

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        id: json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
      };
}
