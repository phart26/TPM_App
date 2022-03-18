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
import 'package:fraction/fraction.dart';

class FinalInspectionGeoForm extends StatefulWidget {
  final PreferencesService pref;

  FinalInspectionGeoForm(this.pref, {Key key}) : super(key: key);
  @override
  _FinalInspectionGeoFormState createState() => _FinalInspectionGeoFormState();
}

class _FinalInspectionGeoFormState extends State<FinalInspectionGeoForm> {
  double height = 0;
  double width = 0;
  bool isLengthChecked = false;
  FocusNode focusNodeLength;
  APICall api;
  TextEditingController _length = TextEditingController();
  TextEditingController _ringA = TextEditingController();
  TextEditingController _ringB = TextEditingController();
  bool idDrift = false;
  double lenVal = 0;
  double lenNegVal = 0;
  double lenPosVal = 0;
  double cutoffLenP = 0;
  double cutoffLenN = 0;
  int qty = 0;
  Map<String, dynamic> data;

  validateLength() {
    if (_length.text.isNotEmpty) {
      String val = "";
      String frac = "";
      String number = "";
      final cutLenPos = Fraction.fromDouble(cutoffLenP);
      final cutLenNeg = Fraction.fromDouble(cutoffLenN);
      val = _length.text;

      if (val.contains(new RegExp(r'[@#\$%&*\-=!:;\?,\(\)]'))) {
        setState(() {
          isLengthChecked = true;
        });
      } else {
        if (val.indexOf(' ') != -1) {
          frac = val.substring(val.indexOf(' ') + 1);
          number = val.substring(0, val.indexOf(' '));
          final lenPlus = (lenVal.toFraction()) + cutLenPos;
          final lenNeg = (lenVal.toFraction()) - cutLenNeg;
          final cutLenEntered = (number.toFraction()) + (frac.toFraction());

          if ((cutLenEntered >= lenNeg) && (cutLenEntered <= lenPlus)) {
            setState(() {
              isLengthChecked = false;
            });
            //displayMessage();
          } else {
            setState(() {
              isLengthChecked = true;
            });
          }
        } else {
          final lenPlus = (lenVal.toFraction()) + cutLenPos;
          final lenNeg = (lenVal.toFraction()) - cutLenNeg;
          final cutLenEntered = val.toFraction();
          if ((cutLenEntered >= lenNeg) && (cutLenEntered <= lenPlus)) {
            setState(() {
              isLengthChecked = false;
            });
            //displayMessage();
          } else {
            setState(() {
              isLengthChecked = true;
            });
          }
        }
      }
    }
  }

  @override
  void initState() {
    api = APICall();
    setState(() {
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
    });

    //round length value to nearest 1/16"
    if (data['final_len_geo'].indexOf('.') != -1) {
      lenVal = double.parse(data['final_len_geo']
              .substring(0, data['final_len_geo'].indexOf('.'))) +
          (((double.parse(data['final_len_geo']
                          .substring(data['final_len_geo'].indexOf('.'))) *
                      16)
                  .round()) /
              16.0);
    } else {
      lenVal = double.parse(data['final_len_geo']);
    }

    lenPosVal =
        ((double.parse(data['formData']['finLenPos']) * 16).round()) / 16.0;
    lenNegVal =
        ((double.parse(data['formData']['finLenNeg']) * 16).round()) / 16.0;
    cutoffLenP =
        ((double.parse(data['formData']['cutoffLengthP']) * 16).round()) / 16.0;
    cutoffLenN =
        ((double.parse(data['formData']['cutoffLengthM']) * 16).round()) / 16.0;

    focusNodeLength = FocusNode();
    focusNodeLength.addListener(() {
      if (!focusNodeLength.hasFocus) {
        validateLength();
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
        title: Text('Final Inspection GeoForm'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: width * .30,
                          child: RaisedButton(
                            color: secondaryColor,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.modeSelection);
                            },
                            child: Text('Home Page',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: width * .30,
                          child: RaisedButton(
                            color: secondaryColor,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  Routes.tubeSelectionScreen);
                            },
                            child: Text('Tube Selction',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _partInfo(),
              orderInfoCard(),
              tubeEditCard(widget.pref.currentTubeNo),
            ],
          ),
        ),
      ),
    );
  }

  _partInfo() {
    final cutLenPos = Fraction.fromDouble(cutoffLenP);
    final cutLenNeg = Fraction.fromDouble(cutoffLenN);
    final cutLen = lenVal;
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
                              'Weld Spec Repair: ${data['formData']['repairSpec'] ?? '--'}',
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
                              'Min. Travel Speed: ${data['formData']['repairSpeed'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        if (data['final_len_geo'].indexOf('.') == -1)
                          SizedBox(
                            width: width * 0.45,
                            child: Text(
                                'Length: ' +
                                    data['final_len_geo'].toString() +
                                    ' +' +
                                    cutLenPos.toString() +
                                    ' -' +
                                    cutLenNeg.toString(),
                                style: bigBoldFontStyle.copyWith(fontSize: 22)),
                          ),
                        if (data['final_len_geo'].indexOf('.') != -1)
                          SizedBox(
                            width: width * 0.45,
                            child: Text(
                                'Cutoff: ' +
                                    (cutLen.toMixedFraction()).toString() +
                                    ' +' +
                                    cutLenPos.toString() +
                                    ' -' +
                                    cutLenNeg.toString(),
                                style: bigBoldFontStyle.copyWith(fontSize: 22)),
                          ),
                        SizedBox(
                          width: width * 0.48,
                          child: Text(
                              'Filler Rod: ${data['formData']['fillerRod'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith(fontSize: 21)),
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
                              'Repair Amps: ${data['formData']['repairAmps'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.48,
                          child: Text(
                              'Repair Volts: ${data['formData']['repairVolts'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Tube remaining: ' +
                              data['tubesToFinInsp'].toString(),
                          style: bigFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Inspector: ${widget.pref.userDetails.userName}',
                          style: bigFontStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                      height: 80,
                      width: (width - 40) / 2,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width * 0.20,
                            child: Text(
                              'ID Drift: Fail',
                              style: bigBoldFontStyle,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.1,
                            child: Switch(
                              activeColor: Colors.green,
                              inactiveTrackColor: Colors.red,
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
                              'Pass',
                              textAlign: TextAlign.end,
                              style: bigBoldFontStyle,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: (width - 40) / 2,
                    height: 80,
                    padding: EdgeInsets.only(left: 10.0, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
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
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 80,
                    width: (width - 40) / 2,
                    padding: EdgeInsets.only(left: 10.0, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: _ringA,
                      decoration: InputDecoration(
                        hintText: 'No. for Ring A',
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
                      controller: _ringB,
                      keyboardType: TextInputType.numberWithOptions(),
//                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'No. for Ring B',
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

                          if (_ringA.text.isNotEmpty &&
                              _ringB.text.isNotEmpty &&
                              !isLengthChecked &&
                              idDrift) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "final_insp_geo": {
                                  "tube_id": "${widget.pref.currentTubeNo}",
                                  "id_drift": "P",
                                  "length_check3": "${_length.text}",
                                  "ring_num1": "${_ringA.text}",
                                  "ring_num2": "${_ringB.text}",
                                  "inspector":
                                      "${widget.pref.userDetails.userId}"
                                }
                              }
                            };
                            await api.postTubeData(map);

                            //Update the api
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);

                            //ending job
                            if (int.parse(data['tubesToFinInsp']) == 0) {
                              Map<String, dynamic> endMap = {
                                "endData": {
                                  "endJob": 1,
                                  "job": '${widget.pref.jobId}',
                                }
                              };
                              await api.postEndJob(endMap);
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.modeSelection);
                            }

                            clearForm();
                            setState(() {});

                            if (int.parse(data['tubesToFinInsp']) == 0) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.modeSelection);
                            }
                            Flushbar(
                              title: "Tube Data Saved",
                              message: "Data saved successfully",
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            )..show(context);

                            Navigator.of(context).pushReplacementNamed(
                                Routes.tubeSelectionScreen);
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
    _length.clear();
    _ringA.clear();
    _ringB.clear();
    idDrift = false;
  }
}
