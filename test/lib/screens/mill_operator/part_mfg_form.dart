import 'dart:convert';
import 'dart:math';

import 'package:f_logs/model/flog/flog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model.dart';
import 'package:tpmapp/models/mesh_model.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:fraction/fraction.dart';

class PartMfgFrom extends StatefulWidget {
  final PreferencesService pref;
  PartMfgFrom(this.pref, {Key key}) : super(key: key);
  @override
  _PartMfgFromState createState() => _PartMfgFromState();
}

class _PartMfgFromState extends State<PartMfgFrom> {
  List<Coils> coils = [];
  Coils selCoil;
  List<Meshs> meshs = [];
  Meshs selMeshTop;
  Meshs selMeshBot;
  List<Meshs> drainages = [];
  Meshs selDrainageTop;
  Meshs selDrainageBot;
  double height = 0;
  double width = 0;
  double startAngle = 0;
  Map<String, dynamic> data;
  double cutoffLenP = 0;
  double cutoffLenN = 0;
  double finLenP = 0;
  double finLenN = 0;
  APICall api;
  @override
  void initState() {
    api = APICall();
    data = json.decode(widget.pref.jobData);

    print(" data of colis ${data['formData']['coils']}");
    if (data['formData']['coils'] != null) {
      coils = coilsFromJson(json.encode(data['formData']['coils'])) ?? [];
      selCoil = coils[0];
    } else
      coils = [];
    if (data['formData']['mesh'].length > 0) {
      meshs = meshsFromJson(json.encode(data['formData']['mesh']));
      selMeshTop = meshs[0];
      selMeshBot = meshs[0];
    } else {
      meshs = [];
    }
    if (data['formData']['mesh'].length > 0) {
      drainages = meshsFromJson(json.encode(data['formData']['mesh']));
      selDrainageTop = drainages[0];
      selDrainageBot = drainages[0];
    } else {
      drainages = [];
    }
    if (data['formData'] != null)
      FLog.info(
          text:
              "data loaded for ${widget.pref.jobId} from partinfo with coil: ${coils.length} mesh: ${meshs.length}");
    else
      FLog.error(
          text:
              "data not loaded for ${widget.pref.jobId} from partinfo with coil: ${coils.length} mesh: ${meshs.length}");
    cutoffLenP =
        ((double.parse(data['formData']['cutoffLengthP']) * 16).round()) / 16.0;
    cutoffLenN =
        ((double.parse(data['formData']['cutoffLengthM']) * 16).round()) / 16.0;
    finLenP =
        ((double.parse(data['formData']['finLenPos']) * 16).round()) / 16.0;
    finLenN =
        ((double.parse(data['formData']['finLenNeg']) * 16).round()) / 16.0;
    startAngle = num.parse((asin(double.parse(data['formData']['stripWidth']) /
                (3.1459 * double.parse(data['formData']['od']))) *
            (180 / 3.1459))
        .toStringAsFixed(2));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Part & Mfg info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: width * .30,
              child: RaisedButton(
                color: secondaryColor,
                onPressed: () async {
                  await api.getData(widget.pref);
                  setState(() {
                    data = json.decode(widget.pref.jobData);
                    if (data['formData']['coils'] != null) {
                      coils = coilsFromJson(
                              json.encode(data['formData']['coils'])) ??
                          [];
                      selCoil = coils[0];
                    } else
                      coils = [];
                    if (data['formData']['mesh'].length > 0) {
                      meshs =
                          meshsFromJson(json.encode(data['formData']['mesh']));
                      selMeshTop = meshs[0];
                      selMeshBot = meshs[0];
                    } else {
                      meshs = [];
                    }
                    if (data['formData']['mesh'].length > 0) {
                      drainages =
                          meshsFromJson(json.encode(data['formData']['mesh']));
                      selDrainageTop = drainages[0];
                      selDrainageBot = drainages[0];
                    } else {
                      drainages = [];
                    }
                    if (data['formData'] != null)
                      FLog.info(
                          text:
                              "data loaded for ${widget.pref.jobId} from partinfo with coil: ${coils.length} mesh: ${meshs.length}");
                    else
                      FLog.error(
                          text:
                              "data not loaded for ${widget.pref.jobId} from partinfo with coil: ${coils.length} mesh: ${meshs.length}");
                    // converting lengths to a 1/16"
                    cutoffLenP =
                        ((double.parse(data['formData']['cutoffLengthP']) * 16)
                                .round()) /
                            16.0;
                    cutoffLenN =
                        ((double.parse(data['formData']['cutoffLengthM']) * 16)
                                .round()) /
                            16.0;
                    finLenP =
                        ((double.parse(data['formData']['finLenPos']) * 16)
                                .round()) /
                            16.0;
                    finLenN =
                        ((double.parse(data['formData']['finLenNeg']) * 16)
                                .round()) /
                            16.0;
                    startAngle = num.parse((asin(
                                double.parse(data['formData']['stripWidth']) /
                                    (3.1459 *
                                        double.parse(data['formData']['od']))) *
                            (180 / 3.1459))
                        .toStringAsFixed(2));
                  });
                },
                child: Text('Refresh',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            _getPartInfo(),
            _cardWeldingInfo(),
            _getMfgNotes(),
            _getUserInputs(),
            SizedBox(
              width: width * 0.9,
              child: RaisedButton(
                  onPressed: () async {
                    if (meshs.length > 0) {
                      if (selMeshTop.meshNo == selMeshBot.meshNo &&
                          selMeshTop.meshNo == selDrainageTop.meshNo &&
                          selMeshTop.meshNo == selDrainageBot.meshNo &&
                          selMeshBot.meshNo == selDrainageTop.meshNo &&
                          selMeshBot.meshNo == selDrainageBot.meshNo &&
                          selDrainageTop.meshNo == selDrainageBot.meshNo) {
                        Flushbar(
                          title: "Same Mesh selected",
                          message: "Please select a different mesh",
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } else {
                        Map<String, dynamic> map = {
                          "tubeData": {
                            "first_tube": {
                              "job": '${widget.pref.jobId}',
                              "setup_op": "${widget.pref.userDetails.userId}",
                              "qty": data['formData']['quantity'],
                              "new_coil": 1,
                              "coil": selCoil.coilNo,
                              "new_filter_top": 1,
                              "filter_mesh_top": selMeshTop.meshNo,
                              "new_filter_bot": 1,
                              "filter_mesh_bot": selMeshBot.meshNo,
                              "new_drain_top": 1,
                              "drain_mesh_top": selDrainageTop.meshNo,
                              "new_drain_bot": 1,
                              "drain_mesh_bot": selDrainageBot.meshNo,
                            }
                          }
                        };
                        await api.postTubeData(map);

                        Navigator.of(context)
                            .pushReplacementNamed(Routes.testScreen);
                      }
                    } else {
                      Map<String, dynamic> map = {
                        "tubeData": {
                          "first_tube": {
                            "job": '${widget.pref.jobId}',
                            "setup_op": "${widget.pref.userDetails.userId}",
                            "qty": data['formData']['quantity'],
                            "new_coil": 1,
                            "coil": selCoil.coilNo,
                          }
                        }
                      };
                      await api.postTubeData(map);

                      Navigator.of(context)
                          .pushReplacementNamed(Routes.testScreen);
                    }
                  },
                  color: primaryColor,
                  child: Text(
                    'Ok',
                    style: bigFontStyle.copyWith(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPartInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
                height: 40,
                width: width * 0.97,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Part Info',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//                        Text('Part Info',
//                            style: bigBoldFontStyle.copyWith(fontSize: 25)),
                  SizedBox(height: 5),
                  Text("Ship Date: ${data['formData']['shipDate'] ?? '--'}",
                      style: bigFontStyle),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text("Job: ${data['formData']['job'] ?? '--'}",
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Part#: ${data['formData']['partNum'] ?? "--"}',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Type: ${data['formData']['material'] ?? "--"}',
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Tube Mill#: ${data['formData']['mill'] ?? "--"}',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Steel Width: ${data['formData']['stripWidth'] ?? "--"} ',
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Die Size: ${data['formData']['dieID'] ?? "--"}',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              "Mat'l Gage: ${data['formData']['gage'] ?? "--"} ",
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.47,
                          child: Text(
                              'Weld Spec Mill: ${data['formData']['millSpec'] ?? "--"}',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Thickness: ${data['formData']['thickness'] ?? "--"}',
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.37,
                          child: Text(
                              'Hole: ${data['formData']['fractionsHole'] ?? "--"} ',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Hole Pattern:  ${data['formData']['pattern'] ?? "--"}',
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Centers: ${data['formData']['fractionsCenter'] ?? "--"}',
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text("Start Angle: " + startAngle.toString(),
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.47,
                          child: Text(
                              "Tube OD: ${data['formData']['od'] ?? "--"} +${data['formData']['odPos'] ?? "--"} -${data['formData']['odNeg'] ?? "--"}",
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                          width: width * 0.45,
                          child: Text(
                              "Tube ID drift:${data['formData']['idDrift'] ?? "--"}",
                              style: bigFontStyle)),
                      SizedBox(
                          width: width * 0.47,
                          child: Text(
                              "Dimple Depth: ${data['formData']['dimpleDepth'] ?? "--"} +${data['formData']['dimpleDepthP'] ?? "--"} -${data['formData']['dimpleDepthM'] ?? "--"}",
                              style: bigFontStyle)),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Torch height: ${data['formData']['millTorchHeight'] ?? "--"}',
                            style: bigFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Arc Length: ${data['formData']['archLength'] ?? "--"}',
                            style: bigFontStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Torch angle: ${data['formData']['torchAngle'] ?? "--"}',
                            style: bigFontStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardWeldingInfo() {
    final cutLenPos = Fraction.fromDouble(cutoffLenP);
    final cutLenNeg = Fraction.fromDouble(cutoffLenN);
    final finishLenPos = Fraction.fromDouble(finLenP);
    final finishLenNeg = Fraction.fromDouble(finLenN);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
                height: 40,
                width: width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Welding info',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.30,
                        child: Text('Job#: ${data['formData']['job']}',
                            style: bigBoldFontStyle.copyWith()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Total Order: ${data['formData']['quantity'] ?? "10"}',
                            style: bigBoldFontStyle.copyWith()),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Min. Travel Speed :  ${data['formData']['millSpeed'] ?? '--'}',
                            style: bigBoldFontStyle.copyWith()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Cutoff: ' +
                                data['formData']['cutoffLength'].toString() +
                                ' +' +
                                cutLenPos.toString() +
                                ' -' +
                                cutLenNeg.toString(),
                            style: bigBoldFontStyle.copyWith(fontSize: 22)),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Finished Length: ' +
                                data['formData']['length'].toString() +
                                ' +' +
                                finishLenPos.toString() +
                                ' -' +
                                finishLenNeg.toString(),
                            style: bigBoldFontStyle.copyWith(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.90,
                        child: Text(
                            'OD: ${data['formData']['od'] ?? "--"} +${data['formData']['odPos'] ?? "--"} -${data['formData']['odNeg'] ?? "--"}',
                            style: bigBoldFontStyle.copyWith(fontSize: 22)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Amps:  ${data['formData']['amps'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Volts: ${data['formData']['volts'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMfgNotes() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
                height: 40,
                width: width * 0.97,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'MFG Notes',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//                  Text('MFG Notes', style: bigBoldFontStyle.copyWith(fontSize: 25)),
                  SizedBox(height: 5),
                  SizedBox(
                    width: width * 0.95,
                    child: Text(
                      data['formData']['notes'] ??
                          'MAX OD: 7.310\" Must drift with 6.979 +0.010\" drift. \nBlank ends tolerance must be within 2.7\" +\/-0.30\ ',
                      style: bigFontStyle,
                      textAlign: TextAlign.left,
                    ),
//                    Text(
//                      '- BURR OUT.\n- USE DRIFT SIZE 4.075".\n- FILTER 01 LAYER 316L, 14X88, 5.80" WIDE.\n- FILTER 02 LAYER 316L, 14X88, 5.80" WIDE.'
//                      '\n- DRAINAGE LAYER 316L, 20X20, 5.80" WIDE.'
//                      '\n*DRAINAGE LAYER SITS ON OTR SHRD,\nFIRST FILTER LYR SITS ON DRAINAGE LAYER,\nSECOND FILTER LYR SITS ON FIRST FILTER LYR\nBUT OFFSET 1/2 THE WIDTH OF THE FIRST FILTER LYR.',
//                      style: bigFontStyle,
//                      textAlign: TextAlign.left,
//                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getUserInputs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
                height: 40,
                width: width * 0.97,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Coil and Mesh',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: width * 0.9,
                    child: Text("Coils", style: bigFontStyle),
                  ),
                  SizedBox(
                    width: width * 0.9,
                    child: DropdownButtonFormField(
                      //decoration: InputDecoration(labelText: 'Coil'),
                      isExpanded: true,
                      value: selCoil,
                      onChanged: (v) {
                        selCoil = v;
                      },
                      items: coils.map<DropdownMenuItem<Coils>>((Coils value) {
                        return DropdownMenuItem<Coils>(
                          value: value,
                          child: Text('${value.coilNo} ${value.gage}'),
                        );
                      }).toList(),
                    ),
                  ),
                  if (meshs.length > 0) SizedBox(height: 5),
                  if (meshs.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: Text("Top Filter Mesh", style: bigFontStyle),
                    ),
                  if (meshs.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: DropdownButtonFormField(
                        //decoration: InputDecoration(labelText: 'Filter Mesh'),
                        isExpanded: true,
                        value: selMeshTop,
                        onChanged: (v) {
                          selMeshTop = v;
                        },
                        items:
                            meshs.map<DropdownMenuItem<Meshs>>((Meshs value) {
                          return DropdownMenuItem<Meshs>(
                            value: value,
                            child: Text('${value.meshNo} ${value.meshType}'),
                          );
                        }).toList(),
                      ),
                    ),
                  if (meshs.length > 0) SizedBox(height: 5),
                  if (meshs.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: Text("Bottom Filter Mesh", style: bigFontStyle),
                    ),
                  if (meshs.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: DropdownButtonFormField(
                        //decoration: InputDecoration(labelText: 'Filter Mesh'),
                        isExpanded: true,
                        value: selMeshBot,
                        onChanged: (v) {
                          selMeshBot = v;
                        },
                        items:
                            meshs.map<DropdownMenuItem<Meshs>>((Meshs value) {
                          return DropdownMenuItem<Meshs>(
                            value: value,
                            child: Text('${value.meshNo} ${value.meshType}'),
                          );
                        }).toList(),
                      ),
                    ),
                  if (drainages.length > 0) SizedBox(height: 5),
                  if (drainages.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: Text("Top Drainage Mesh", style: bigFontStyle),
                    ),
                  if (drainages.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: DropdownButtonFormField(
                        //decoration: InputDecoration(labelText: 'Drainage Mesh'),
                        isExpanded: true,
                        value: selDrainageTop,
                        onChanged: (v) {
                          selDrainageTop = v;
                        },
                        items: drainages
                            .map<DropdownMenuItem<Meshs>>((Meshs value) {
                          return DropdownMenuItem<Meshs>(
                            value: value,
                            child: Text('${value.meshNo} ${value.meshType}'),
                          );
                        }).toList(),
                      ),
                    ),
                  if (drainages.length > 0) SizedBox(height: 5),
                  if (drainages.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: Text("Bottom Drainage Mesh", style: bigFontStyle),
                    ),
                  if (drainages.length > 0)
                    SizedBox(
                      width: width * 0.9,
                      child: DropdownButtonFormField(
                        //decoration: InputDecoration(labelText: 'Drainage Mesh'),
                        isExpanded: true,
                        value: selDrainageBot,
                        onChanged: (v) {
                          selDrainageBot = v;
                        },
                        items: drainages
                            .map<DropdownMenuItem<Meshs>>((Meshs value) {
                          return DropdownMenuItem<Meshs>(
                            value: value,
                            child: Text('${value.meshNo} ${value.meshType}'),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
