// To parse this JSON data, do
//
//     final coils = coilsFromJson(jsonString);

import 'dart:convert';

List<Coils> coilsFromJson(String str) =>
    List<Coils>.from(json.decode(str).map((x) => Coils.fromJson(x)));

String coilsToJson(List<Coils> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Coils {
  Coils({
    this.coilNo,
    this.gage,
  });

  String coilNo;
  String gage;

  factory Coils.fromJson(Map<String, dynamic> json) => Coils(
        coilNo: json["coil_no"],
        gage: json["gage"],
      );

  Map<String, dynamic> toJson() => {
        "coil_no": coilNo,
        "gage": gage,
      };
}
