// To parse this JSON data, do
//
//     final inspectionJobDetails = inspectionJobDetailsFromJson(jsonString);

import 'dart:convert';

List<InspectionJobDetails> inspectionJobDetailsFromJson(String str) =>
    List<InspectionJobDetails>.from(
        json.decode(str).map((x) => InspectionJobDetails.fromJson(x)));

String inspectionJobDetailsToJson(List<InspectionJobDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InspectionJobDetails {
  InspectionJobDetails({
    this.jobId,
    this.dPI,
    this.iSCs,
    this.fIGf,
    this.cSCs,
    this.gFRI,
    this.rSCs,
    // this.tWs,
  });

  String jobId;
  CSCs dPI;
  CSCs iSCs;
  CSCs fIGf;
  CSCs cSCs;
  CSCs gFRI;
  CSCs rSCs;
  // CSCs tWs;

  factory InspectionJobDetails.fromJson(Map<String, dynamic> json) =>
      InspectionJobDetails(
        jobId: json["job_id"],
        dPI: CSCs.fromJson(json["d_p_i"]),
        iSCs: CSCs.fromJson(json["i_s_cs"]),
        fIGf: CSCs.fromJson(json["f_i_gf"]),
        cSCs: CSCs.fromJson(json["c_s_cs"]),
        gFRI: CSCs.fromJson(json["g_f_r_i"]),
        rSCs: CSCs.fromJson(json["r_s_cs"]),
        // tWs: CSCs.fromJson(json["t_w_s"]),
      );

  Map<String, dynamic> toJson() => {
        "job_id": jobId,
        "d_p_i": dPI.toJson(),
        "i_s_cs": iSCs.toJson(),
        "f_i_gf": fIGf.toJson(),
        "c_s_cs": cSCs.toJson(),
        "g_f_r_i": gFRI.toJson(),
        "r_s_cs": rSCs.toJson(),
        // "t_w_s": tWs.toJson(),
      };
}

class CSCs {
  CSCs({
    this.qty,
    this.tubes,
  });

  int qty;
  List<Tube> tubes;

  factory CSCs.fromJson(Map<String, dynamic> json) => CSCs(
        qty: json["qty"],
        tubes: List<Tube>.from(json["tubes"].map((x) => Tube.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "tubes": List<dynamic>.from(tubes.map((x) => x.toJson())),
      };
}

class Tube {
  Tube({
    this.tubeNo,
    this.isCompleted,
  });

  String tubeNo;
  bool isCompleted;

  factory Tube.fromJson(Map<String, dynamic> json) => Tube(
        tubeNo: json["tube_no"],
        isCompleted: json["isCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "tube_no": tubeNo,
        "isCompleted": isCompleted,
      };
}
