import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:fraction/fraction.dart';

class GeoCutoffStationCheckSheet extends StatefulWidget {
  final PreferencesService pref;

  GeoCutoffStationCheckSheet(this.pref, {Key key}) : super(key: key);
  @override
  _GeoCutoffStationCheckSheetState createState() =>
      _GeoCutoffStationCheckSheetState();
}

class _GeoCutoffStationCheckSheetState
    extends State<GeoCutoffStationCheckSheet> {
  bool isBladeChange = false;
  double height = 0;
  double width = 0;
  double lenVal = 0;
  double lenNegVal = 0;
  double lenPosVal = 0;
  double cutoffLenP = 0;
  double cutoffLenN = 0;

  bool isFilter = false;
  bool _issueLenStart = true;
  bool _issueLenEnd = true;
  bool tubeAvail = true;
  int tubesFinished = 0;
  FocusNode focusNodeLenStart;
  APICall api;
  TextEditingController _length = TextEditingController();
  TextEditingController _remarks = TextEditingController();
  TextEditingController _heat = TextEditingController();
  TextEditingController _manufacture = TextEditingController();
  int remTubes = 0;
  int qty = 0;
  Map<String, dynamic> data;
  List<InspectionJobDetails> details;

  validateLength() {
    String val = "";
    String frac = "";
    String number = "";
    final cutLenPos = Fraction.fromDouble(cutoffLenP);
    final cutLenNeg = Fraction.fromDouble(cutoffLenN);
    val = _length.text;

    if (val.contains(new RegExp(r'[@#\$%&*\-=!:;\?,\(\)]'))) {
      setState(() {
        _issueLenStart = true;
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
            _issueLenStart = false;
          });
          //displayMessage();
        } else {
          setState(() {
            _issueLenStart = true;
          });
        }
      } else {
        final lenPlus = (lenVal.toFraction()) + cutLenPos;
        final lenNeg = (lenVal.toFraction()) - cutLenNeg;
        final cutLenEntered = val.toFraction();
        if ((cutLenEntered >= lenNeg) && (cutLenEntered <= lenPlus)) {
          setState(() {
            _issueLenStart = false;
          });
          //displayMessage();
        } else {
          setState(() {
            _issueLenStart = true;
          });
        }
      }
    }
  }

  @override
  void initState() {
    //call this after each saved tube
    //- for api call grab all tubes that have been welded and not cutoff into an array and just return the tube in spot 0
    //make that tube id the next tube number
    //everything else the same
    api = APICall();
    // TODO: implement initState
    setState(() {
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
      //round length value to nearest 1/16"
      if (data['formData']['length'].indexOf('.') != -1) {
        lenVal = double.parse(data['formData']['length']
                .substring(0, data['formData']['length'].indexOf('.'))) +
            (((double.parse(data['formData']['length'].substring(
                            data['formData']['length'].indexOf('.'))) *
                        16)
                    .round()) /
                16.0);
      } else {
        lenVal = double.parse(data['formData']['length']);
      }

      lenPosVal =
          ((double.parse(data['formData']['finLenPos']) * 16).round()) / 16.0;
      lenNegVal =
          ((double.parse(data['formData']['finLenNeg']) * 16).round()) / 16.0;
      cutoffLenP =
          ((double.parse(data['formData']['cutoffLengthP']) * 16).round()) /
              16.0;
      cutoffLenN =
          ((double.parse(data['formData']['cutoffLengthM']) * 16).round()) /
              16.0;
    });

    if (int.parse(data['tubesCut']) == qty) {
      setState(() {
        isFilter = true;
      });
    }

    super.initState();
    focusNodeLenStart = new FocusNode();
    focusNodeLenStart.addListener(() {
      if (!focusNodeLenStart.hasFocus) {
        if (_length.text.isNotEmpty) {
          String val = "";
          String frac = "";
          String number = "";
          final cutLenPos = Fraction.fromDouble(cutoffLenP);
          final cutLenNeg = Fraction.fromDouble(cutoffLenN);
          val = _length.text;

          if (val.contains(new RegExp(r'[@#\$%&*\-=!:;\?,\(\)]'))) {
            setState(() {
              _issueLenStart = true;
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
                  _issueLenStart = false;
                });
                //displayMessage();
              } else {
                setState(() {
                  _issueLenStart = true;
                });
              }
            } else {
              final lenPlus = (lenVal.toFraction()) + cutLenPos;
              final lenNeg = (lenVal.toFraction()) - cutLenNeg;
              final cutLenEntered = val.toFraction();
              if ((cutLenEntered >= lenNeg) && (cutLenEntered <= lenPlus)) {
                setState(() {
                  _issueLenStart = false;
                });
                //displayMessage();
              } else {
                setState(() {
                  _issueLenStart = true;
                });
              }
            }
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
      appBar: AppBar(
        title: Text('Cutoff Station - Check Sheet'),
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
              _inspectionInfo(),
              orderInfoCard(),
              if (tubeAvail) tubeEditCard(widget.pref.currentTubeNo),
            ],
          ),
        ),
      ),
    );
  }

  _inspectionInfo() {
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
                    'Welding info',
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
                        if (data['formData']['length'].indexOf('.') == -1)
                          SizedBox(
                            width: width * 0.45,
                            child: Text(
                                'Cutoff: ' +
                                    data['formData']['length'].toString() +
                                    ' +' +
                                    cutLenPos.toString() +
                                    ' -' +
                                    cutLenNeg.toString(),
                                style: bigBoldFontStyle.copyWith(fontSize: 22)),
                          ),
                        if (data['formData']['length'].indexOf('.') != -1)
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
                              'OD: ${data['formData']['od'] ?? "--"} +${data['formData']['odPos'] ?? "--"} -${data['formData']['odNeg'] ?? "--"}',
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
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Tubes remaining: ' + data['tubesCut'].toString(),
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
            )
          ],
        ),
      ),
    );
  }

  Widget tubeEditCard(String title) {
    if (int.parse((widget.pref.currentTubeNo).substring(5)) == 1)
      setState(() {
        isFilter = true;
      });
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
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _length,
                  focusNode: focusNodeLenStart,
                  decoration: InputDecoration(
                    hintText: 'Length Check',
                    fillColor: (_issueLenStart) ? Colors.red : Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: (_issueLenStart) ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              if (_issueLenStart)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Please enter a valid Length!!!',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  controller: _remarks,
//                  keyboardType: TextInputType.number,
//                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    border: new OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                  ),
                  if (int.parse(data['tubesCut']) <= qty)
                    SizedBox(
                      width: width * 0.5,
                      child: Text('New Filler Rod',
                          style: bigFontStyle.copyWith()),
                    ),
                  if (int.parse(data['tubesCut']) < qty)
                    Switch(
                      activeColor: primaryColor,
                      value: isFilter,
                      onChanged: (value) {
                        print("VALUE : $value");
                        setState(() {
                          isFilter = value;
                        });
                      },
                    ),
                ],
              ),
              if (isFilter)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    //keyboardType: TextInputType.number,
//                  readOnly: true,
                    controller: _heat,
                    decoration: InputDecoration(
                      hintText: 'Filler Rod Heat Number',
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isFilter)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
//                  readOnly: true,
                    controller: _manufacture,
                    decoration: InputDecoration(
                      hintText: 'Filler Rod Manufacture',
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: Colors.grey,
                        ),
                      ),
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
                          validateLength();
                          if ((!_issueLenStart) &&
                              ((isFilter)
                                  ? (_heat.text.isNotEmpty &&
                                      _manufacture.text.isNotEmpty)
                                  : true)) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "cutoff": {
                                  "tube_id": "${widget.pref.currentTubeNo}",
                                  "length_check1": "${_length.text}",
                                  "remarks_cut": "${_remarks.text}",
                                  "cut_op": "${widget.pref.userDetails.userId}",
                                  "heat_num_cutoff":
                                      isFilter ? "${_heat.text}" : "",
                                  "manufac_cutoff":
                                      isFilter ? _manufacture.text : "",
                                }
                              }
                            };
                            await api.postTubeData(map);

                            //Update the api
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);

                            clearForm();
                            setState(() {});
                            if (int.parse(data['tubesCut']) == 0) {
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
    _remarks.clear();
    _heat.clear();
    _manufacture.clear();
    isFilter = false;
  }
}
