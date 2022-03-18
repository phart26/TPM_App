import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/constants/routes_name.dart';

class FinalInspectionGeoForm extends StatefulWidget {
  final PreferencesService pref;

  FinalInspectionGeoForm(this.pref, {Key key}) : super(key: key);
  @override
  _FinalInspectionGeoFormState createState() => _FinalInspectionGeoFormState();
}

class _FinalInspectionGeoFormState extends State<FinalInspectionGeoForm> {
  double height = 0;
  double width = 0;
  bool isOdChecked = false;
  bool isLengthChecked = false;
  int remTubes = 0;
  FocusNode focusNodeLength;
  APICall api;
  TextEditingController _length = TextEditingController();
  TextEditingController _idDrift = TextEditingController();
  TextEditingController _weld = TextEditingController();
  TextEditingController _repair = TextEditingController();
  TextEditingController _ringOne = TextEditingController();
  TextEditingController _ringTwo = TextEditingController();
  FocusNode focusNodeOdChecked;
  TextEditingController _odChecked = TextEditingController();
  TextEditingController _reason = TextEditingController();
  bool weld = false;
  bool idDrift = false;
  double odVal = 0;
  double odNegVal = 0;
  double odPosVal = 0;
  double lenVal = 0;
  double lenNegVal = 0;
  double lenPosVal = 0;
  int qty = 0;
  Map<String, dynamic> data;
  List<InspectionJobDetails> details;

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
    setState(() {
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
      details = inspectionJobDetailsFromJson(widget.pref.jobwisetubeDetails);
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
        title: Text('Final Inspection Geo Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _partInfo(),
//              SizedBox(height: 8),
              orderInfoCard(),
              tubeEditCard(widget.pref.currentTubeNo),
            ],
          ),
        ),
      ),
    );
  }

  _partInfo() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(children: [
            SizedBox(
              height: 50,
              width: width * .30,
              child: RaisedButton(
                color: secondaryColor,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.jobScreen);
                },
                child: Text('Job List',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
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
                    'Part info',
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
                              'Total Order: ${data['formData']['quantity'] ?? '--'}',
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
                          width: width * 0.9,
                          child: Text(
                              'OD: ${data['formData']['od'] ?? "--"} ${data['formData']['odPos'] ?? "--"} ${data['formData']['odNeg'] ?? "--"}',
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
                              'ID Drift: ${data['formData']['idDrift'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: Text('Drift inspected: (+ or - .002)',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Length: ${data['formData']['length'] ?? "--"} -${data['formData']['finLenNeg'] ?? "--"} +${data['formData']['finLenPos'] ?? "--"}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: Row(
                            children: [
                              Text('Dimensions:',
                                  style: bigBoldFontStyle.copyWith()),
                              Container(
                                  height: 20,
                                  width: width * 0.25,
                                  child: TextField()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Row(
                            children: [
                              Text('By:', style: bigBoldFontStyle.copyWith()),
                              Container(
                                  height: 20,
                                  width: width * 0.40,
                                  child: TextField()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ]),
        ));
  }

  Widget orderInfoCard() {
    remTubes = MyUtils.calRemainingJob(data, details, 'fIGf');
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Tube remaining: $remTubes',
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
//                  SizedBox(height: 5),
//                  Text(
//                    'Date tubes inspected : 07/22/2020- 07/23/2020',
//                    style: bigFontStyle,
//                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tubeEditCard(String title) {
    setValues();
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
                                      await MyUtils.updateTubeNumber(details,
                                          data, widget.pref, 'fIGf', qty);
                                      remTubes = MyUtils.calRemainingJob(
                                          data, details, 'fIGf');
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
              Row(
                children: [
//                  Container(
//                    height: 80,
//                    width: (width - 40) / 2,
//                    padding: EdgeInsets.only(left: 10.0, top: 20),
//                    child: TextField(
//                      keyboardType: TextInputType.number,
////                      readOnly: true,
//                      controller: _idDrift,
//                      decoration: InputDecoration(
//                        hintText: 'ID Drift',
//                        border: new OutlineInputBorder(
//                          borderSide: new BorderSide(
//                            color: Colors.grey,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                  Container(
                      height: 80,
                      width: (width - 40) / 2,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width * 0.20,
                            child: Text(
                              'ID Drift: Pass',
                              style: bigBoldFontStyle,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: Switch(
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.green,
                              onChanged: (v) {
                                setState(() {
                                  idDrift = v;
                                });
                              },
                              value: idDrift,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: Text(
                              'Fail',
                              textAlign: TextAlign.end,
                              style: bigBoldFontStyle,
                            ),
                          ),
                        ],
                      )),
                  Container(
                      width: (width - 40) / 2,
                      height: 80,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: TextField(
                        keyboardType: TextInputType.number,
//                      readOnly: true,
                        focusNode: focusNodeOdChecked,
                        controller: _odChecked,
                        decoration: InputDecoration(
                          hintText: 'OD',
                          fillColor: (isOdChecked) ? Colors.red : Colors.white,
                          filled: true,
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (width - 40) / 2,
                    height: 80,
                    padding: EdgeInsets.only(left: 10.0, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
//                      readOnly: true,
                      controller: _length,
                      focusNode: focusNodeLength,
                      decoration: InputDecoration(
                        fillColor:
                            (isLengthChecked) ? Colors.red : Colors.white,
                        filled: true,
                        hintText: 'Length',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: 80,
                      width: (width - 40) / 2,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width * 0.20,
                            child: Text(
                              'Weld: Pass',
                              style: bigBoldFontStyle,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: Switch(
                              activeColor: Colors.red,
                              inactiveTrackColor: Colors.green,
                              onChanged: (v) {
                                setState(() {
                                  weld = v;
                                });
                              },
                              value: weld,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: Text(
                              'Fail',
                              textAlign: TextAlign.end,
                              style: bigBoldFontStyle,
                            ),
                          ),
                        ],
                      )
//                    TextField(
//                      keyboardType: TextInputType.number,
//                      controller: _weld,
////                      readOnly: true,
//                      decoration: InputDecoration(
//                        hintText: 'Weld',
//                        border: new OutlineInputBorder(
//                          borderSide: new BorderSide(
//                            color: Colors.grey,
//                          ),
//                        ),
//                      ),
//                    ),
                      ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
//                  readOnly: true,
                  controller: _repair,
                  decoration: InputDecoration(
                    hintText: 'Repairs',
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 80,
                    width: (width - 40) / 2,
                    padding: EdgeInsets.only(left: 10.0, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
//                      readOnly: true,
                      controller: _ringOne,
                      decoration: InputDecoration(
                        hintText: 'Ring No. 1',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: (width - 40) / 2,
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      controller: _ringTwo,
                      keyboardType: TextInputType.numberWithOptions(),
//                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Ring No. 2',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      SizedBox(height: 8),
                      Text(
                          'Inspection Notes:  ${data['formData']['inspNotes'] ?? "--"}',
                          style: bigFontStyle.copyWith(fontSize: 18)),
                      SizedBox(height: 8),
                      Text(
                          'I certify that the above tubes comply with the criteria listed on this form.',
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
                          await validateLength();
                          await validateOD();

                          if (
                              // _idDrift.text.isNotEmpty &&
                              _repair.text.isNotEmpty &&
                                  // _weld.text.isNotEmpty &&
                                  !isOdChecked &&
                                  !isLengthChecked) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "final_insp_geo": {
                                  "tube_id": "${widget.pref.currentTubeNo}",
                                  "id_drift": idDrift ? "F" : "P",
                                  "od_check3": "${_odChecked.text}",
                                  "length_check2": "${_length.text}",
                                  "weld": weld ? "F" : "P",
                                  "repairs": "${_repair.text}",
                                  "ring_num1": "${_ringOne.text}",
                                  "ring_num2": "${_ringTwo.text}",
                                  "inspector":
                                      "${widget.pref.userDetails.userId}"
                                }
                              }
                            };
                            await api.postTubeData(map);
                            clearForm();
                            await MyUtils.updateTubeNumber(
                                details, data, widget.pref, 'fIGf', qty);
                            remTubes =
                                MyUtils.calRemainingJob(data, details, 'fIGf');
                            setState(() {});
                            Flushbar(
                              title: "Tube Data Saved",
                              message: "Data saved successfully",
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            )..show(context);
                          } else {
                            Flushbar(
                              title: "Invalid value",
                              message: "Please enter all valid values",
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
  }

  clearForm() {
    setValues();
    _length.clear();
    _odChecked.clear();
    _weld.clear();
    _repair.clear();
    _ringOne.clear();
    _ringTwo.clear();
    _repair.clear();
    _reason.clear();
  }

  setValues() {
    _idDrift.text = data['formData']['idDrift'];
//    _idDrift.text = data['formData']['idDrift'];
  }
}
