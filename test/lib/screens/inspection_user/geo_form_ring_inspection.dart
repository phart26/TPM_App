import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/constants/routes_name.dart';

class GeoFormRingInspection extends StatefulWidget {
  final PreferencesService pref;

  GeoFormRingInspection(this.pref, {Key key}) : super(key: key);
  @override
  _GeoFormRingInspectionState createState() => _GeoFormRingInspectionState();
}

class _GeoFormRingInspectionState extends State<GeoFormRingInspection> {
  double height = 0;
  double width = 0;
  bool isOdChecked = false;
  bool isLengthChecked = false;
  bool finish = false;
  bool od = false;
  bool id = false;
  bool length = false;
  APICall api;
  int remTubes = 0;
  TextEditingController _idDrift = TextEditingController();
  TextEditingController _odChecked = TextEditingController();
  TextEditingController _length = TextEditingController();
  TextEditingController _finish = TextEditingController();
  TextEditingController _reason = TextEditingController();
  double odVal = 0;
  double odNegVal = 0;
  double odPosVal = 0;
  double lenVal = 0;
  double lenNegVal = 0;
  double lenPosVal = 0;

  FocusNode focusNodeLength;
  FocusNode focusNodeOdChecked;
  int qty = 0;
  Map<String, dynamic> data;
  validateLength() {
    if (_length.text.isNotEmpty) {
      double val = 0;
      try {
        val = double.parse(_length.text);
        print(' $val ${lenVal - lenNegVal} ${lenVal + lenPosVal}');
        if (val < NumberFormatter.roundDouble(lenVal - lenNegVal, 2) ||
            val > NumberFormatter.roundDouble(lenVal + lenPosVal, 2)) {
          isLengthChecked = true;
        } else {
          isLengthChecked = false;
        }
        print('isleghtChecked $isLengthChecked');
      } catch (e) {
        print('issue with length check $e');
        isLengthChecked = true;
      }
      setState(() {});
    }
  }

  validateOD() {
    if (_odChecked.text.isNotEmpty) {
      double val = 0;
      try {
        val = double.parse(_odChecked.text);
        print(' $val ${odVal - odNegVal} ${odVal + odPosVal}');
        if (val < NumberFormatter.roundDouble(odVal - odNegVal, 2) ||
            val > NumberFormatter.roundDouble(odVal + odPosVal, 2)) {
          isOdChecked = true;
        } else {
          isOdChecked = false;
        }
        print('isOdChecked $isOdChecked');
      } catch (e) {
        print('issue with od check $e');
        isOdChecked = true;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    api = APICall();
    // TODO: implement initState
    setState(() {
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
//      if (data != null) _tubeLength.text = data['formData'][''];
    });
    odVal = double.parse(data['formData']['od'] ?? "0");
    odPosVal = double.parse(data['formData']['odPos'] ?? "0");
    odNegVal = double.parse(data['formData']['odNeg'] ?? "0");
    lenVal = double.parse(data['formData']['length'] ?? "0");
    lenPosVal = double.parse(data['formData']['finLenPos'] ?? "0");
    lenNegVal = double.parse(data['formData']['finLenNeg'] ?? "0");
    focusNodeLength = FocusNode();
    focusNodeOdChecked = FocusNode();
    focusNodeLength.addListener(() {
      if (!focusNodeLength.hasFocus) {
        validateLength();
      }
    });
    focusNodeOdChecked.addListener(() {
      if (!focusNodeOdChecked.hasFocus) {
        validateOD();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo Form Ring Inspection'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: width * .30,
                child: RaisedButton(
                  color: secondaryColor,
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.jobScreen);
                  },
                  child: Text('Job List',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              _inspectionInfo(),
//              SizedBox(height: 8),
              orderInfoCard(),
              tubeEditCard(widget.pref.currentTubeNo),
              notesCard(),
            ],
          ),
        ),
      ),
    );
  }

  _inspectionInfo() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(children: [
            Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Inspection info',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Job#: ${data['formData']['job'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Drawing: ${data['formData']['drawingNum'] ?? '--'}',
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
                              'Total Order: ${data['formData']['quantity'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'PO#: ${data['formData']['poNum'] ?? '--'}',
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
                              'Cutoff: ${data['formData']['cutoffLength'] ?? '--'}  +${data['formData']['cutoffLengthP'] ?? '--'}  +${data['formData']['cutoffLengthM'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith(fontSize: 21)),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'TPM Batch: G-${data['formData']['job'] ?? '--'}',
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
                              'OD: ${data['formData']['od'] ?? "--"} ${data['formData']['odPos'] ?? "--"} ${data['formData']['odNeg'] ?? "--"}',
                              style: bigBoldFontStyle.copyWith(fontSize: 21)),
                        ),
                      ],
                    ),
                  ],
                ))
          ]),
        ));
  }

  Widget orderInfoCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Order info',
                    style: bigBoldFontStyle.copyWith(color: Colors.white),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Rings remaining: $remTubes',
                      style: bigFontStyle,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Inspector: S M Shaikh',
                      style: bigFontStyle,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  notesCard() {
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
//                        keyboardType: TextInputType.number,
//                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          labelText: 'Notes',
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
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
                              onPressed: () {},
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
                ))));
  }

  Widget tubeEditCard(String title) {
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
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        '$title',
                        style: bigBoldFontStyle.copyWith(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: width * 0.45,
                      child: RaisedButton(
                        color: secondaryColor,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Container(
                                  height: 150,
                                  width: 250,
                                  child: Column(
                                    children: [
                                      Text(
                                          'Do you want to mark this tube as scrap'),
                                      SizedBox(
                                        height: 100,
                                        width: 200,
                                        child: TextField(
                                          controller: _reason,
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                              labelText: "Reason"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  RaisedButton(
                                    onPressed: () async {
                                      await api.postScarp(
                                          widget.pref,
                                          _reason.text ?? "",
                                          "",
                                          data['formData']['length'] ?? "",
                                          "I");
                                      clearForm();
                                      setState(() {});
                                      Navigator.of(context).pop();
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
                        child: const Text('Scrap',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          'ID: Pass',
                          style: bigBoldFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.2,
                        child: Switch(
                          activeColor: Colors.red,
                          inactiveTrackColor: Colors.green,
                          onChanged: (v) {
                            setState(() {
                              id = v;
                            });
                          },
                          value: id,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          'Fail',
                          textAlign: TextAlign.end,
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ],
                  )
//                TextField(
//                  controller: _idDrift,
//                  keyboardType: TextInputType.number,
////                  readOnly: true,
//                  decoration: InputDecoration(
//                    hintText: 'ID',
////                    fillColor: (_issueOdStart) ? Colors.red : Colors.white,
////                    filled: true,
//                    border: new OutlineInputBorder(
//                      borderSide: new BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
                  ),
              Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          'OD: Pass',
                          style: bigBoldFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.2,
                        child: Switch(
                          activeColor: Colors.red,
                          inactiveTrackColor: Colors.green,
                          onChanged: (v) {
                            setState(() {
                              od = v;
                            });
                          },
                          value: od,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          'Fail',
                          textAlign: TextAlign.end,
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ],
                  )
//                  TextField(
//                    keyboardType: TextInputType.number,
//                    focusNode: focusNodeOdChecked,
//                    controller: _odChecked,
//                    decoration: InputDecoration(
//                      hintText: 'OD',
//                      fillColor: (isOdChecked) ? Colors.red : Colors.white,
//                      filled: true,
//                      border: new OutlineInputBorder(
//                        borderSide: new BorderSide(
//                          color: Colors.grey,
//                        ),
//                      ),
//                    ),
//                  )
                  ),
              Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          'Length: Pass',
                          style: bigBoldFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.20,
                        child: Switch(
                          activeColor: Colors.red,
                          inactiveTrackColor: Colors.green,
                          onChanged: (v) {
                            setState(() {
                              length = v;
                            });
                          },
                          value: length,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.30,
                        child: Text(
                          'Fail',
                          textAlign: TextAlign.end,
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ],
                  )
//                TextField(
//                  keyboardType: TextInputType.number,
////                      readOnly: true,
//                  controller: _length,
//                  focusNode: focusNodeLength,
//                  decoration: InputDecoration(
//                    fillColor: (isLengthChecked) ? Colors.red : Colors.white,
//                    filled: true,
//                    hintText: 'Length',
//                    border: new OutlineInputBorder(
//                      borderSide: new BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
                  ),
              Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.35,
                        child: Text(
                          'Finish: Pass',
                          style: bigBoldFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.20,
                        child: Switch(
                          activeColor: Colors.red,
                          inactiveTrackColor: Colors.green,
                          onChanged: (v) {
                            setState(() {
                              finish = v;
                            });
                          },
                          value: finish,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.30,
                        child: Text(
                          'Fail',
                          textAlign: TextAlign.end,
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ],
                  )

//                TextField(
////                  readOnly: true,
//                  controller: _finish,
//                  decoration: InputDecoration(
//                    hintText: 'Finish',
//                    border: new OutlineInputBorder(
//                      borderSide: new BorderSide(
//                        color: Colors.grey,
//                      ),
//                    ),
//                  ),
//                ),
                  ),
              SizedBox(
                width: width - 16,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Key P = Passes N= None  WL = With in limits',
                          style: bigFontStyle.copyWith(fontSize: 18)),
                    ],
                  ),
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
//                          await validateLength();
//                          await validateOD();

//                          if (_idDrift.text.isNotEmpty &&
//                              _finish.text.isNotEmpty &&
//                              !isOdChecked &&
//                              !isLengthChecked) {
                          Map<String, dynamic> map = {
                            "tubeData": {
                              "geo_ring_insp": {
                                "ring_id": "${widget.pref.currentTubeNo}",
                                "job": "${widget.pref.jobId}",
                                "inspector":
                                    "${widget.pref.userDetails.userId}",
                                "batch_num": "G-${widget.pref.jobId}",
                                "ID": id ? "F" : "P",
                                "OD": od ? "F" : "P",
                                "length_check": length ? "F" : "P",
                                "finish": finish ? "F" : "P"
                              },
                            }
                          };
                          await api.postTubeData(map);
                          clearForm();
                          setState(() {});
                          Flushbar(
                            title: "Ring Data Saved",
                            message: "Data saved successfully",
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          )..show(context);
//                          } else {
//                            Flushbar(
//                              title: "Invalid value",
//                              message: "Please enter all valid values",
//                              backgroundColor: Colors.red,
//                              duration: Duration(seconds: 2),
//                            )..show(context);
//                          }
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
  }

  clearForm() {
//    setValues();
//    _length.clear();
//    _odChecked.clear();
//    _finish.clear();
//    _idDrift.clear();
    id = false;
    od = false;
    length = false;
    finish = false;
    _reason.clear();
  }
}
