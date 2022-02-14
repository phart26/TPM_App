// To parse this JSON data, do
//
//     final meshs = meshsFromJson(jsonString);

import 'dart:convert';

List<Meshs> meshsFromJson(String str) =>
    List<Meshs>.from(json.decode(str).map((x) => Meshs.fromJson(x)));

String meshsToJson(List<Meshs> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Meshs {
  Meshs({
    this.meshNo,
    this.meshType,
  });

  String meshNo;
  String meshType;

  factory Meshs.fromJson(Map<String, dynamic> json) => Meshs(
        meshNo: json["mesh_no"],
        meshType: json["mesh_type"],
      );

  Map<String, dynamic> toJson() => {
        "mesh_no": meshNo,
        "mesh_type": meshType,
      };
}
