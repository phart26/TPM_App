import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model.dart';
import 'package:tpmapp/models/mesh_model.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:fraction/fraction.dart';

class WeldingCheckSheetForm extends StatefulWidget {
  final PreferencesService pref;

  WeldingCheckSheetForm(this.pref, {Key key}) : super(key: key);

  @override
  _WeldingCheckSheetFormState createState() => _WeldingCheckSheetFormState();
}

class _WeldingCheckSheetFormState extends State<WeldingCheckSheetForm> {
  TextEditingController _odStart = TextEditingController();
  TextEditingController _odEnd = TextEditingController();
  TextEditingController _reason = TextEditingController();
  TextEditingController _scrapLength = TextEditingController();
  TextEditingController _weightCoil = TextEditingController();
  TextEditingController _remarks = TextEditingController();
  FocusNode focusNodeOdStart;
  FocusNode focusNodeOdEnd;
  bool started = false;
  bool isCoil = false;
  bool isMeshTop = false;
  bool isMeshBot = false;
  bool isDrainageTop = false;
  bool isDrainageBot = false;
  bool _issueOdStart = false;
  bool _issueOdEnd = false;
  bool _isjobCompleted = false;
  bool isScrap = false;
  bool isFirstTube = true;
  int qty = 0;
  int currentTube = 0;
  double odVal = 0;
  double odNegVal = 0;
  double odPosVal = 0;
  String nextTube = "";
  String lastTube = "";
  double cutoffLenP = 0;
  double cutoffLenN = 0;

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
  APICall api;
  Map<String, dynamic> data;
  @override
  void initState() {
    api = APICall();
    data = json.decode(widget.pref.jobData);
    setState(() {
      if (int.parse(data['tubesMill']) ==
          int.parse(data['formData']['quantity'])) {
        if (data['formData']['firstCoils'].length > 0) {
          coils =
              coilsFromJson(json.encode(data['formData']['firstCoils'])) ?? [];
          selCoil = coils.length > 0 ? coils[0] : '';
        } else
          coils = [];
        if (data['formData']['firstMesh'].length > 0) {
          meshs = meshsFromJson(json.encode(data['formData']['firstMesh']));
          selMeshTop = meshs[0];
          selMeshBot = meshs[1];
        } else {
          meshs = [];
        }
        if (data['formData']['firstMesh'].length > 0) {
          drainages = meshsFromJson(json.encode(data['formData']['firstMesh']));
          selDrainageTop = drainages[2];
          selDrainageBot = drainages[3];
        } else {
          drainages = [];
        }
      } else {
        isFirstTube = false;
        if (data['formData']['currentCoil'].length > 0) {
          coils =
              coilsFromJson(json.encode(data['formData']['currentCoil'])) ?? [];
          selCoil = coils.length > 0 ? coils[0] : '';
        } else
          coils = [];
        if (data['formData']['currentMesh'].length > 0) {
          meshs = meshsFromJson(json.encode(data['formData']['currentMesh']));
          selMeshTop = meshs[0];
          selMeshBot = meshs[1];
        } else {
          meshs = [];
        }
        if (data['formData']['currentMesh'].length > 0) {
          drainages =
              meshsFromJson(json.encode(data['formData']['currentMesh']));
          selDrainageTop = drainages[2];
          selDrainageBot = drainages[3];
        } else {
          drainages = [];
        }
      }
    });
    qty = int.parse(data['formData']['quantity'] ?? "10");
    odVal = double.parse(data['formData']['od'] ?? "0");
    odPosVal = double.parse(data['formData']['odPos'] ?? "0");
    odNegVal = double.parse(data['formData']['odNeg'] ?? "0");
    started = widget.pref.isOrderStarted;
    cutoffLenP =
        ((double.parse(data['formData']['cutoffLengthP']) * 16).round()) / 16.0;
    cutoffLenN =
        ((double.parse(data['formData']['cutoffLengthM']) * 16).round()) / 16.0;

    // if (data['formData']['nextTubeMill'] == "" && int.parse(data['tubesMill']) == qty) {
    //   widget.pref.currentTube = 1;
    //   widget.pref.currentTubeNo = generateTubeNumber(widget.pref.currentTube);
    // } else {
    //   widget.pref.currentTubeNo = data['formData']['nextTubeMill'];
    //   widget.pref.currentTube = int.parse(widget.pref.currentTubeNo
    //       .substring(widget.pref.currentTubeNo.indexOf('-') + 1));
    // }

    if (data['formData']['nextTubeMill'] != "") {
      widget.pref.currentTubeNo = data['formData']['nextTubeMill'];
      widget.pref.currentTube = int.parse(widget.pref.currentTubeNo
          .substring(widget.pref.currentTubeNo.indexOf('-') + 1));
    } else if (data['formData']['nextTube'] == "") {
      widget.pref.currentTube = 1;
      widget.pref.currentTubeNo = generateTubeNumber(widget.pref.currentTube);
    } else {
      widget.pref.currentTubeNo = data['formData']['nextTube'];
      widget.pref.currentTube = int.parse(widget.pref.currentTubeNo
          .substring(widget.pref.currentTubeNo.indexOf('-') + 1));
    }

    super.initState();
    focusNodeOdStart = new FocusNode();
    focusNodeOdStart.addListener(() {
      if (!focusNodeOdStart.hasFocus) {
        if (_odStart.text.isNotEmpty) {
          double val = 0;
          try {
            val = double.parse(_odStart.text ?? "0");
          } on FormatException {
            val = 0;
          }
          print('${odVal - odNegVal} ${odVal + odPosVal}');
          if (val < NumberFormatter.roundDouble(odVal - odNegVal, 3) ||
              val > NumberFormatter.roundDouble(odVal + odPosVal + .004, 3)) {
            setState(() {
              _issueOdStart = true;
            });
            //displayMessage();
          } else {
            setState(() {
              _issueOdStart = false;
            });
          }
        }
      }
    });
    focusNodeOdEnd = new FocusNode();
    focusNodeOdEnd.addListener(() {
      if (!focusNodeOdEnd.hasFocus) {
        if (_odEnd.text.isNotEmpty) {
          double val = 0;
          try {
            val = double.parse(_odEnd.text ?? "0");
          } on FormatException {
            val = 0;
          }
          print('${odVal - odNegVal} ${odVal + odPosVal}');
          if (val < NumberFormatter.roundDouble(odVal - odNegVal, 3) ||
              val > NumberFormatter.roundDouble(odVal + odPosVal + .004, 3)) {
//            displayMessage();
            setState(() {
              _issueOdEnd = true;
            });
          } else {
            setState(() {
              _issueOdEnd = false;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('TPM Welding-Station Check Sheet')),
      body: SingleChildScrollView(
          child: Container(
//              height: height,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: width * .30,
                        child: RaisedButton(
                          color: secondaryColor,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.loginScreen);
                          },
                          child: Text('Log Out',
                              style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: width * .30,
                        child: RaisedButton(
                          color: secondaryColor,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.partMfgInfo);
                          },
                          child: Text('Set-Up Sheet',
                              style:
                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    child: _cardWeldingInfo(),
                  ),
                  if (int.parse(data['tubesMill']) == qty)
                    SizedBox(
                      width: width * 0.95,
                      child: RaisedButton(
                          onPressed: () async {
                            //setting the material to material of inital setup
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);
                            setState(() {
                              if (data['formData']['firstCoils'].length > 0) {
                                coils = coilsFromJson(
                                    json.encode(data['formData']['firstCoils'])) ??
                                    [];
                                selCoil = coils.length > 0 ? coils[0] : '';
                              } else
                                coils = [];
                              if (data['formData']['firstMesh'].length > 0) {
                                meshs = meshsFromJson(
                                    json.encode(data['formData']['firstMesh']));
                                selMeshTop = meshs[0];
                                selMeshBot = meshs[1];
                              } else {
                                meshs = [];
                              }
                              if (data['formData']['firstMesh'].length > 0) {
                                drainages = meshsFromJson(
                                    json.encode(data['formData']['firstMesh']));
                                selDrainageTop = drainages[2];
                                selDrainageBot = drainages[3];
                              } else {
                                drainages = [];
                              }
                            });
                            widget.pref.isOrderStarted = true;

                            setState(() {
                              started = true;
                            });
                          },
                          color: primaryColor,
                          child: Text(
                            'Start Order',
                            style: bigFontStyle.copyWith(color: Colors.white),
                          )),
                    ),
                  if (started ||
                      data['formData']['nextTubeMill'] != "" ||
                      data['formData']['nextTube'] != "")
                    SizedBox(width: width * 0.97, child: orderStartedInfoCard()),
                  SizedBox(
                    height: 10,
                  ),
                  if ((int.parse(data['tubesMill']) == 0) &&
                      (data['formData']['nextTubeMill'] == ""))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.5,
                            child: Text('No Tubes Available',
                                style: bigFontStyle.copyWith(color: Colors.black)),
                          ),
                          SizedBox(
                            height: 50,
                            width: width * .49,
                            child: RaisedButton(
                              color: secondaryColor,
                              onPressed: () async {
                                //Update the api
                                await api.getData(widget.pref);

                                setState(() {
                                  data = json.decode(widget.pref.jobData);
                                  if (data['formData']['nextTubeMill'] != "") {
                                    widget.pref.currentTubeNo =
                                    data['formData']['nextTubeMill'];
                                    widget.pref.currentTube = int.parse(
                                        widget.pref.currentTubeNo.substring(
                                            widget.pref.currentTubeNo.indexOf('-') +
                                                1));
                                  } else if (data['formData']['nextTube'] == "") {
                                    widget.pref.currentTube = 1;
                                    widget.pref.currentTubeNo =
                                        generateTubeNumber(widget.pref.currentTube);
                                  } else {
                                    widget.pref.currentTubeNo =
                                    data['formData']['nextTube'];
                                    widget.pref.currentTube = int.parse(
                                        widget.pref.currentTubeNo.substring(
                                            widget.pref.currentTubeNo.indexOf('-') +
                                                1));
                                  }
                                });
                              },
                              child: Text('Refresh',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if ((started && (int.parse(data['tubesMill']) != 0)) ||
                      data['formData']['nextTubeMill'] != "" ||
                      data['formData']['nextTube'] != "")
                    tubeEditCard(widget.pref.currentTubeNo),
                ],
              ))),
    );
  }

  Widget displayMessage() {
    Flushbar(
      title: "Invalid value",
      message: "Please enter value in range",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  Widget orderStartedInfoCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 40,
              width: width,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Order info',
                  style: bigBoldFontStyle.copyWith(color: Colors.white),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mill Operator: ${widget.pref.userDetails.userName}',
                        style: bigFontStyle,
                      ),
                      Text(
                        'Tubes Remaining: ' + data['tubesMill'].toString(),
                        style: bigFontStyle,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardWeldingInfo() {
    final cutLenPos = Fraction.fromDouble(cutoffLenP);
    final cutLenNeg = Fraction.fromDouble(cutoffLenN);
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
                        width: width * 0.90,
                        child: Text(
                            'Cutoff: ' +
                                data['formData']['cutoffLength'].toString() +
                                ' +' +
                                cutLenPos.toString() +
                                ' -' +
                                cutLenNeg.toString(),
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
                            'Amps:  ${data['formData']['millAmps'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Volts: ${data['formData']['millVolts'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tubeEditCard(String title) {
    if (int.parse(data['tubesMill']) != 0)
      return Container(
        width: width * 0.97,
        child: Card(
          elevation: 10,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 0.74, color: Colors.white)),
          margin: EdgeInsets.only(
            left: 10,
            right: 5,
            bottom: 5,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child:
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                            '$title',
                            style: bigBoldFontStyle.copyWith(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ),
                      Expanded(child:
                        SizedBox(
                          height: 50,
                          width: width * 0.45,
                          child: ElevatedButton(
                            style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.blue) ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      height: 220,
                                      width: 300,
                                      child: Column(
                                        children: [
                                          Expanded(child:
                                            SizedBox(
                                              height: 100,
                                              width: 200,
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: _scrapLength,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                    labelText: "Scrap Length"),
                                              ),
                                            )
                                          ),
                                          Expanded(child:
                                            SizedBox(
                                              height: 100,
                                              width: 200,
                                              child: TextField(
                                                controller: _reason,
                                                maxLines: 3,
                                                decoration: InputDecoration(
                                                    labelText: "Reason for scrap"),
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await api.postScarp(
                                              widget.pref,
                                              _reason.text ?? "",
                                              selCoil.coilNo ?? "",
                                              _scrapLength.text ?? "",
                                              "M");
                                          clearForm();

                                          Navigator.of(context).pop();
                                        },
                                        // color: Colors.green,
                                        style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.green) ),
                                        child: Text('Scrap'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        // color: Colors.red,
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                                        child: Text('No'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Scrap',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _odStart,
                    focusNode: focusNodeOdStart,
                    decoration: InputDecoration(
                      hintText: 'OD Check ',
                      fillColor: (_issueOdStart) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (_issueOdStart) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_issueOdStart)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Please enter valid OD value!!!',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                Container(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10, top: 20, bottom: 80),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _odEnd,
                    focusNode: focusNodeOdEnd,
                    decoration: InputDecoration(
                      hintText: 'OD Check',
                      fillColor: (_issueOdEnd) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(
                          color: (_issueOdEnd) ? Colors.red : Colors.grey,
                        ),
                      ),
//                    enabledBorder: new OutlineInputBorder(
//                      borderSide: BorderSide(
//                        color: (_issueOdEnd) ? Colors.red : Colors.grey,
//                      ),
//                    ),
                    ),
                  ),
                ),
                if (_issueOdEnd)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Please enter valid OD value!!!',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
//              Container(
//                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
//                child: TextField(
//                  controller: _remarks,
//                  decoration: InputDecoration(
//                    hintText: 'Remarks',
//                    border: new OutlineInputBorder(
//                      borderSide: new BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
//              ),

                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 80),
                  // Coil deallocation box
                  child: SizedBox(
                    height: 50,
                    width: width * 0.3,
                    child: RaisedButton(
                      color: primaryColor,
                      onPressed: () {
                        BuildContext dialogContext;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            dialogContext = context;
                            return AlertDialog(
                              title: Text('Confirm'),
                              content: Container(
                                height: 100,
                                width: 250,
                                child: Column(
                                  children: [
                                    Text('Do you want to end current coil?',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Map<String, dynamic> material = {
                                      "materialData": {
                                        "coil_no": selCoil.coilNo ?? ""
                                      }
                                    };
                                    await api.postMaterialData(material);
                                    await api.getData(widget.pref);
                                    data = json.decode(widget.pref.jobData);

                                    //update new material
                                    setState(() {
                                      if (data['formData']['coils'].length > 0) {
                                        coils = coilsFromJson(json.encode(data['formData']['coils'])) ?? [];
                                      } else {
                                        coils = [];
                                      }
                                      isCoil = true;
                                      // }
                                    });
                                    showDialog(
                                      context: dialogContext,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Select New Coil'),
                                          content: Container(
                                            height: 150,
                                            width: 500,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 15),
                                                SizedBox(
                                                  width: width * 0.9,
                                                  child:
                                                  DropdownButtonFormField(
                                                    isExpanded: true,
                                                    value: selCoil,
                                                    onChanged: (v) {
                                                      selCoil = v;
                                                    },
                                                    items: coils.map<DropdownMenuItem<Coils>>((Coils value) {
                                                          return DropdownMenuItem<Coils>(
                                                            value: value,
                                                            child: Text( '${value.coilNo} ${value.gage}',
                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(dialogContext);
                                              },
                                              color: Colors.green,
                                              child: Text('Select'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  // style: Colors.green,
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                                  child: Text('Yes'),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  color: Colors.red,
                                  child: Text('No'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('End Coil',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Filter mesh deallocation box
                      if (data['formData']['mesh'].length > 0)
                        SizedBox(
                          height: 50,
                          width: width * 0.3,
                          child: RaisedButton(
                            color: secondaryColor,
                            onPressed: () {
                              BuildContext dialogContext;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                              'Do you want to end Top filter mesh?',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () async {
                                          Map<String, dynamic> material = {
                                            "materialData": {
                                              "filter_no":
                                              selMeshTop.meshNo ?? ""
                                            }
                                          };
                                          await api.postMaterialData(material);
                                          await api.getData(widget.pref);
                                          data =
                                              json.decode(widget.pref.jobData);

                                          //update new material
                                          setState(() {
                                            if (data['formData']['mesh']
                                                .length >
                                                0) {
                                              meshs = meshsFromJson(json.encode(
                                                  data['formData']['mesh']));
                                              // selMeshTop = meshs[0];
                                            } else {
                                              meshs = [];
                                            }
                                            isMeshTop = true;
                                          });
                                          showDialog(
                                            context: dialogContext,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Select New Top Filter Mesh'),
                                                content: Container(
                                                  height: 150,
                                                  width: 500,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15),
                                                      SizedBox(
                                                        width: width * 0.9,
                                                        child:
                                                        DropdownButtonFormField(
//                    decoration: InputDecoration(labelText: 'Filter Mesh'),
                                                          isExpanded: true,
                                                          value: selMeshTop,
                                                          onChanged: (v) {
                                                            selMeshTop = v;
                                                          },
                                                          items: meshs.map<
                                                              DropdownMenuItem<
                                                                  Meshs>>((Meshs
                                                          value) {
                                                            if (value.meshNo ==
                                                                selDrainageTop
                                                                    .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshBot
                                                                        .meshNo ||
                                                                value.meshNo ==
                                                                    selDrainageBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              );
                                                            if (value.meshNo !=
                                                                selDrainageTop
                                                                    .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshBot
                                                                        .meshNo &&
                                                                value.meshNo !=
                                                                    selDrainageBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight.bold)),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    color: Colors.green,
                                                    child: Text('Select'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: Colors.green,
                                        child: Text('Yes'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.red,
                                        child: Text('No'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('End Top Fil. Mesh',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      // Bottom Filter mesh deallocation box
                      if (data['formData']['mesh'].length > 0)
                        SizedBox(
                          height: 50,
                          width: width * 0.3,
                          child: RaisedButton(
                            color: secondaryColor,
                            onPressed: () {
                              BuildContext dialogContext;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                              'Do you want to end bottom filter mesh?',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () async {
                                          Map<String, dynamic> material = {
                                            "materialData": {
                                              "filter_no":
                                              selMeshBot.meshNo ?? ""
                                            }
                                          };
                                          await api.postMaterialData(material);
                                          await api.getData(widget.pref);
                                          data =
                                              json.decode(widget.pref.jobData);

                                          //update new material
                                          setState(() {
                                            if (data['formData']['mesh']
                                                .length >
                                                0) {
                                              meshs = meshsFromJson(json.encode(
                                                  data['formData']['mesh']));
                                              // selMeshBot = meshs[0];
                                            } else {
                                              meshs = [];
                                            }
                                            isMeshBot = true;
                                          });
                                          showDialog(
                                            context: dialogContext,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Select New bottom Filter Mesh'),
                                                content: Container(
                                                  height: 150,
                                                  width: 500,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15),
                                                      SizedBox(
                                                        width: width * 0.9,
                                                        child:
                                                        DropdownButtonFormField(
//                    decoration: InputDecoration(labelText: 'Filter Mesh'),
                                                          isExpanded: true,
                                                          value: selMeshBot,
                                                          onChanged: (v) {
                                                            selMeshBot = v;
                                                          },
                                                          items: meshs.map<
                                                              DropdownMenuItem<
                                                                  Meshs>>((Meshs
                                                          value) {
                                                            if (value.meshNo ==
                                                                selDrainageTop
                                                                    .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshTop
                                                                        .meshNo ||
                                                                value.meshNo ==
                                                                    selDrainageBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              );
                                                            if (value.meshNo !=
                                                                selDrainageTop
                                                                    .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshTop
                                                                        .meshNo &&
                                                                value.meshNo !=
                                                                    selDrainageBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight.bold)),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    color: Colors.green,
                                                    child: Text('Select'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: Colors.green,
                                        child: Text('Yes'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.red,
                                        child: Text('No'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('End Bot. Fil. Mesh',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Drain mesh deallocation box
                      if (data['formData']['mesh'].length > 0)
                        SizedBox(
                          height: 50,
                          width: width * 0.3,
                          child: RaisedButton(
                            color: primaryColor,
                            onPressed: () {
                              BuildContext dialogContext;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                              'Do you want to end Top drainage mesh?',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () async {
                                          Map<String, dynamic> material = {
                                            "materialData": {
                                              "drain_no":
                                              selDrainageTop.meshNo ?? ""
                                            }
                                          };
                                          await api.postMaterialData(material);
                                          await api.getData(widget.pref);
                                          data =
                                              json.decode(widget.pref.jobData);

                                          //update new material
                                          setState(() {
                                            if (data['formData']['mesh']
                                                .length >
                                                0) {
                                              drainages = meshsFromJson(
                                                  json.encode(data['formData']
                                                  ['mesh']));
                                              // selDrainageTop = drainages[0];
                                            } else {
                                              drainages = [];
                                            }
                                            isDrainageTop = true;
                                          });

                                          showDialog(
                                            context: dialogContext,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Select New Top Drainage Mesh'),
                                                content: Container(
                                                  height: 150,
                                                  width: 500,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15),
                                                      SizedBox(
                                                        width: width * 0.9,
                                                        child:
                                                        DropdownButtonFormField(
//                    decoration: InputDecoration(labelText: 'Drainage Mesh'),
                                                          isExpanded: true,
                                                          value: selDrainageTop,
                                                          onChanged: (v) {
                                                            selDrainageTop = v;
                                                          },
                                                          items: drainages.map<
                                                              DropdownMenuItem<
                                                                  Meshs>>((Meshs
                                                          value) {
                                                            if (value.meshNo ==
                                                                selDrainageBot
                                                                    .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshTop
                                                                        .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              );
                                                            if (value.meshNo !=
                                                                selDrainageBot
                                                                    .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshTop
                                                                        .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight.bold)),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    color: Colors.green,
                                                    child: Text('Select'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: Colors.green,
                                        child: Text('Yes'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.red,
                                        child: Text('No'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('End Top Drainage',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      // Drain mesh deallocation box
                      if (data['formData']['mesh'].length > 0)
                        SizedBox(
                          height: 50,
                          width: width * 0.3,
                          child: RaisedButton(
                            color: primaryColor,
                            onPressed: () {
                              BuildContext dialogContext;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return AlertDialog(
                                    title: Text('Confirm'),
                                    content: Container(
                                      height: 100,
                                      width: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                              'Do you want to end bottom drainage mesh?',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      RaisedButton(
                                        onPressed: () async {
                                          Map<String, dynamic> material = {
                                            "materialData": {
                                              "drain_no":
                                              selDrainageBot.meshNo ?? ""
                                            }
                                          };
                                          await api.postMaterialData(material);
                                          await api.getData(widget.pref);
                                          data =
                                              json.decode(widget.pref.jobData);

                                          //update new material
                                          setState(() {
                                            if (data['formData']['mesh']
                                                .length >
                                                0) {
                                              drainages = meshsFromJson(
                                                  json.encode(data['formData']
                                                  ['mesh']));
                                              // selDrainageBot = drainages[0];
                                            } else {
                                              drainages = [];
                                            }
                                            isDrainageBot = true;
                                          });

                                          showDialog(
                                            context: dialogContext,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Select New Bottom Drainage Mesh'),
                                                content: Container(
                                                  height: 150,
                                                  width: 500,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15),
                                                      SizedBox(
                                                        width: width * 0.9,
                                                        child:
                                                        DropdownButtonFormField(
//                    decoration: InputDecoration(labelText: 'Drainage Mesh'),
                                                          isExpanded: true,
                                                          value: selDrainageBot,
                                                          onChanged: (v) {
                                                            selDrainageBot = v;
                                                          },
                                                          items: drainages.map<
                                                              DropdownMenuItem<
                                                                  Meshs>>((Meshs
                                                          value) {
                                                            if (value.meshNo ==
                                                                selDrainageTop
                                                                    .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshTop
                                                                        .meshNo ||
                                                                value.meshNo ==
                                                                    selMeshBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              );
                                                            if (value.meshNo !=
                                                                selDrainageTop
                                                                    .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshTop
                                                                        .meshNo &&
                                                                value.meshNo !=
                                                                    selMeshBot
                                                                        .meshNo)
                                                              return DropdownMenuItem<
                                                                  Meshs>(
                                                                value: value,
                                                                child: Text(
                                                                    '${value.meshNo} ${value.meshType}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight.bold)),
                                                              );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      Navigator.pop(
                                                          dialogContext);
                                                    },
                                                    color: Colors.green,
                                                    child: Text('Select'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        color: Colors.green,
                                        child: Text('Yes'),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        color: Colors.red,
                                        child: Text('No'),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('End Bot. Drainage',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: width * 0.92,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: width * 0.90,
                        child: RaisedButton(
                          color: primaryColor,
                          onPressed: () async {
                            bool valOdStart = true;
                            bool valOdEnd = true;
                            if (_odStart.text.isNotEmpty) {
                              double val = double.parse(_odStart.text ?? "0");
                              if (val <
                                  NumberFormatter.roundDouble(
                                      odVal - odNegVal, 3) ||
                                  val >
                                      NumberFormatter.roundDouble(
                                          odVal + odPosVal + .004, 3)) {
                                valOdStart = false;
                                displayMessage();
                              }
                            } else if (_odEnd.text.isNotEmpty) {
                              double val = double.parse(_odEnd.text ?? "0");
                              if (val <
                                  NumberFormatter.roundDouble(
                                      odVal - odNegVal, 3) ||
                                  val >
                                      NumberFormatter.roundDouble(
                                          odVal + odPosVal + .004, 3)) {
                                valOdEnd = false;
                                displayMessage();
                              }
                            }
                            if (_odStart.text.isNotEmpty &&
                                _odEnd.text.isNotEmpty &&
                                valOdStart &&
                                valOdEnd) {
                              Map<String, dynamic> map = {
                                "tubeData": {
                                  "weld_chksheet": {
                                    "setup_op":
                                    "${widget.pref.userDetails.userId}",
                                    "mill_op":
                                    "${widget.pref.userDetails.userId}",
                                    "job": '${widget.pref.jobId}',
                                    "tube_id": '${widget.pref.currentTubeNo}',
                                    "od_check1": '${_odStart.text}',
                                    "od_check2": '${_odEnd.text}',
                                    "new_coil": isCoil ? 1 : 0,
                                    "coil": selCoil.coilNo,
                                    "new_filter_top": isMeshTop ? 1 : 0,
                                    "filter_mesh_top": selMeshTop.meshNo,
                                    "new_filter_bot": isMeshBot ? 1 : 0,
                                    "filter_mesh_bot": selMeshBot.meshNo,
                                    "new_drain_top": isDrainageTop ? 1 : 0,
                                    "drain_mesh_top": selDrainageTop.meshNo,
                                    "new_drain_bot": isDrainageBot ? 1 : 0,
                                    "drain_mesh_bot": selDrainageBot.meshNo,
                                    "scrap_tube": isScrap ? 1 : 0,
                                    "isFirstTube": isFirstTube ? 1 : 0,
                                  }
                                }
                              };
                              await api.postTubeData(map);

                              //Update the api
                              await api.getData(widget.pref);
                              data = json.decode(widget.pref.jobData);
                              nextTube = data['formData']['nextTubeMill'];
                              lastTube = widget.pref.currentTubeNo;

                              if (widget.pref.currentTube < qty) {
                                if (nextTube == "") {
                                  setState(() {
                                    isScrap = false;
                                    widget.pref.currentTubeNo =
                                    data['formData']['nextTube'];
                                    widget.pref.currentTube = int.parse(widget
                                        .pref.currentTubeNo
                                        .substring(widget.pref.currentTubeNo
                                        .indexOf('-') +
                                        1));
                                  });
                                } else {
                                  setState(() {
                                    isScrap = true;
                                    widget.pref.currentTubeNo = nextTube;
                                  });
                                }

                                //only clears form if the tube saved to the database
                                if (lastTube == widget.pref.currentTubeNo) {
                                  Flushbar(
                                    title: "Tube didn't save",
                                    message: "Try exiting out of app",
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 6),
                                  )..show(context);
                                } else {
                                  clearForm();
                                }
                                if (started &&
                                    data['formData']['nextTubeMill'] != "" &&
                                    !isFirstTube) {
                                  Flushbar(
                                    title: "Scrapped tube up next",
                                    message:
                                    "This tube was scrapped at inspection",
                                    backgroundColor: Colors.blue,
                                    duration: Duration(seconds: 6),
                                  )..show(context);
                                }
                              } else {
                                if (data['formData']['nextTube'] == "") {
                                  if (isCoil == false) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Enter weight of unused steel'),
                                          content: Container(
                                            height: 150,
                                            width: 250,
                                            child: Column(
                                              children: [
                                                Text('Weight'),
                                                SizedBox(
                                                  height: 100,
                                                  width: 200,
                                                  child: TextField(
                                                    controller: _weightCoil,
                                                    maxLines: 1,
                                                    decoration: InputDecoration(
                                                        labelText: "lbs"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            RaisedButton(
                                              onPressed: () async {
                                                await api.postWeight(
                                                    widget.pref,
                                                    _weightCoil.text ?? "",
                                                    selCoil.coilNo ?? "");

                                                clearForm();

                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                    Routes.loginScreen);
                                              },
                                              color: Colors.green,
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      _isjobCompleted = true;
                                    });
                                    Navigator.of(context).pushReplacementNamed(
                                        Routes.loginScreen);
                                  }
                                }
                              }

                              setState(() {
                                isFirstTube = false;
                              });
                            } else {
                              //display validate msg
                              Flushbar(
                                title: "Invalid value",
                                message:
                                "Please enter value in range/ all fields",
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          },
                          child: const Text('Save',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      );
    if (int.parse(data['tubesMill']) == 0)
      return SizedBox(
        width: width * 0.97,
        child: Text('All Tubes Completed',
            style: bigFontStyle.copyWith(color: Colors.black)),
      );
  }

  String generateTubeNumber(int currentTube) {
    String ret = "";
    //print('${widget.pref.jobId} ${widget.pref.currentTube} $qty');
    ret = widget.pref.jobId.toString() +
        '-' +
        currentTube.toString().padLeft(qty.toString().length, "0");
    //print('generated number $ret');
    return ret;
  }

  clearForm() {
    isCoil = false;
    isMeshTop = false;
    isMeshBot = false;
    isDrainageTop = false;
    isDrainageBot = false;
    _reason.clear();
    _odStart.clear();
    _odEnd.clear();
    _remarks.clear();
    _scrapLength.clear();
  }
}
