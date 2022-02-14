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
    this.heat,
  });

  String coilNo;
  String heat;

  factory Coils.fromJson(Map<String, dynamic> json) => Coils(
        coilNo: json["coil_no"],
        heat: json["heat"],
      );

  Map<String, dynamic> toJson() => {
        "coil_no": coilNo,
        "heat": heat,
      };
}
