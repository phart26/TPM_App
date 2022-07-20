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

class InspectionStationCheckList extends StatefulWidget {
  final PreferencesService pref;

  InspectionStationCheckList(this.pref, {Key key}) : super(key: key);
  @override
  _InspectionStationCheckListState createState() =>
      _InspectionStationCheckListState();
}

class _InspectionStationCheckListState
    extends State<InspectionStationCheckList> {
  double height = 0;
  double width = 0;
  bool isOdChecked = false;
  bool isLengthChecked = false;
  FocusNode focusNodeLength;
  FocusNode focusNodeIdDrift;
  APICall api;
  bool weld = false;
  bool idDrift = false;
  bool goodIdDrift = false;
  bool dimDrift = false;
  bool displayDim = true;
  bool tubeAvail = false;
  TextEditingController _length = TextEditingController();
  TextEditingController _dim = TextEditingController();
  TextEditingController _dimInsp = TextEditingController();
  TextEditingController _idDrift = TextEditingController();
  TextEditingController _weld = TextEditingController();
  TextEditingController _repair = TextEditingController();
  FocusNode focusNodeOdChecked;
  TextEditingController _odChecked = TextEditingController();
  TextEditingController _reason = TextEditingController();

  double odVal = 0;
  double odNegVal = 0;
  double odPosVal = 0;
  double lenVal = 0;
  double lenNegVal = 0;
  double lenPosVal = 0;
  double dimVal = 0;
  double dimPosVal = 0;
  double dimNegVal = 0;
  double cutoffLenP = 0;
  double cutoffLenN = 0;
  int qty = 0;
  int tubeNo = 0;
  Map<String, dynamic> data;
  // List<InspectionJobDetails> details;
  bool isDataLoading = false;
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

  validateOD() {
    if (_odChecked.text.isNotEmpty) {
      double val = 0;
      try {
        val = double.parse(_odChecked.text);
        print(' $val ${odVal - odNegVal} ${odVal + odPosVal}');
        if (val < NumberFormatter.roundDouble(odVal - odNegVal, 3) ||
            val > NumberFormatter.roundDouble(odVal + odPosVal, 3)) {
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

  validateIdDrift() {
    if (data['formData']['idDrift'] != "") {
      if (_dim.text.isNotEmpty) {
        double val = 0;
        val = double.parse(_dim.text);
        if (val <= dimPosVal && val >= dimNegVal) {
          goodIdDrift = true;
        } else {
          goodIdDrift = false;
        }
        setState(() {});
      }
    } else {
      goodIdDrift = true;
      setState(() {});
    }
  }

  validateIDDriftFT() {
    if ((widget.pref.currentTube == 1) && (data['formData']['idDrift'] != "")) {
      setState(() {
        dimDrift = true;
        displayDim = true;
      });
    } else {
      setState(() {
        dimDrift = false;
        displayDim = false;
      });
    }
  }

  @override
  void initState() {
    //call this after each saved tube
    //seperate API call to return next tube in DB that has been welded and cutoff, but not inspection
    //- for api call grab all tubes that have been welded and cutoff, but not inspected into an array and just return the tube in spot 0
    //make that tube id the next tube number
    //everything else the same
    api = APICall();
    setState(() {
      isDataLoading = true;
    });
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
      // details = inspectionJobDetailsFromJson(widget.pref.jobwisetubeDetails);
    });
    odVal = double.parse(data['formData']['od'] ?? "0");
    odPosVal = double.parse(data['formData']['odPos'] ?? "0");
    odNegVal = double.parse(data['formData']['odNeg'] ?? "0");

    //round length value to nearest 1/16"
    if (data['formData']['length'].indexOf('.') != -1) {
      lenVal = double.parse(data['formData']['length']
              .substring(0, data['formData']['length'].indexOf('.'))) +
          (((double.parse(data['formData']['length']
                          .substring(data['formData']['length'].indexOf('.'))) *
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
        ((double.parse(data['formData']['cutoffLengthP']) * 16).round()) / 16.0;
    cutoffLenN =
        ((double.parse(data['formData']['cutoffLengthM']) * 16).round()) / 16.0;
    if (data['formData']['idDrift'] != "") {
      dimVal = double.parse(data['formData']['idDrift'] ?? "0");
      dimPosVal = dimVal + .002;
      dimNegVal = dimVal - .002;
    } else {
      dimVal = 0;
      dimPosVal = 0;
      dimNegVal = 0;
    }

    if (data['formData']['nextTubeInsp'] != "") {
      widget.pref.currentTubeNo = data['formData']['nextTubeInsp'];
      widget.pref.currentTube = int.parse(widget.pref.currentTubeNo
          .substring(widget.pref.currentTubeNo.indexOf('-') + 1));
      if (widget.pref.currentTube != 1) {
        setState(() {
          idDrift = true;
          goodIdDrift = true;
        });
      }
      setState(() {
        tubeAvail = true;
      });
    } else {
      widget.pref.currentTubeNo = "";
      widget.pref.currentTube = 0;
    }

    // validateIDDriftFT();
    focusNodeLength = FocusNode();
    focusNodeOdChecked = FocusNode();
    focusNodeIdDrift = FocusNode();

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
    if (data['formData']['idDrift'] != "") {
      focusNodeIdDrift.addListener(() {
        if (!focusNodeIdDrift.hasFocus) {
          validateIdDrift();
        }
      });
    } else {
      setState(() {
        goodIdDrift = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection Station Check List'),
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
                                  .pushReplacementNamed(Routes.jobScreen);
                            },
                            child: Text('Job List',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 50,
                            width: width * .30,
                            child: RaisedButton(
                              color: secondaryColor,
                              onPressed: () async {
                                //Update the api
                                await api.getData(widget.pref);

                                setState(() {
                                  data = json.decode(widget.pref.jobData);

                                  if (data['formData']['nextTubeInsp'] == "") {
                                    tubeAvail = false;
                                  } else {
                                    widget.pref.currentTubeNo =
                                        data['formData']['nextTubeInsp'];

                                    widget.pref.currentTube = int.parse(widget
                                        .pref.currentTubeNo
                                        .substring(widget.pref.currentTubeNo
                                                .indexOf('-') +
                                            1));

                                    tubeAvail = true;
                                  }

                                  //setting the dimension display to visible or not
                                  if ((widget.pref.currentTube == 1) &&
                                      dimDrift) {
                                    displayDim = true;
                                  } else {
                                    displayDim = false;
                                  }
                                });
                              },
                              child: Text('Refresh',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _partInfo(),
              orderInfoCard(),
              if (tubeAvail) tubeEditCard(widget.pref.currentTubeNo),
              if (!tubeAvail)
                SizedBox(
                  width: width * 0.97,
                  child: Text('No Tubes Available',
                      style: bigFontStyle.copyWith(color: Colors.black)),
                ),
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
                          width: width * 0.33,
                          child: Text(
                              'Job#: ${data['formData']['job'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.33,
                          child: Text(
                              'Company: ${data['formData']['customer'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.33,
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
                              '${data['formData']['isOd'] == '1' ? 'OD' : 'ID'}: ${data['formData']['od'] ?? "--"} +${data['formData']['odPos'] ?? "--"} -${data['formData']['odNeg'] ?? "--"}',
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
                        if (data['formData']['length'].indexOf('.') == -1)
                          SizedBox(
                            width: width * 0.45,
                            child: Text(
                                'Length: ' +
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
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ))
          ]),
        ));
  }

  Widget orderInfoCard() {
    // remTubes = qty - widget.pref.currentTube + 1;
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
                          'Tubes remaining: ' + data['tubesInsp'].toString(),
                          style: bigFontStyle,
                        ),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Inspector:  ${widget.pref.userDetails.userName}',
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

  setValues() {
    _idDrift.text = data['formData']['idDrift'];
  }

  Widget tubeEditCard(String title) {
    setValues();
    validateIDDriftFT();
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

                                      //Update the api
                                      await api.getData(widget.pref);
                                      data = json.decode(widget.pref.jobData);

                                      if (data['formData']['nextTubeInsp'] == "") {
                                        tubeAvail = false;
                                      } else {
                                        // //check if nextTube is an additional scrap tube to update remaining tubes
                                        // if (int.parse(data['formData']
                                        //             ['nextTubeInsp']
                                        //         .substring(data['formData']
                                        //                 ['nextTubeInsp']
                                        //             .indexOf('-'))) >
                                        //     int.parse(widget.pref.currentTubeNo
                                        //         .substring(widget
                                        //             .pref.currentTubeNo
                                        //             .indexOf('-')))) {
                                        //   widget.pref.currentTube--;
                                        // } else {
                                        //   widget.pref.currentTube++;
                                        // }

                                        widget.pref.currentTubeNo = data['formData']['nextTubeInsp'];

                                        widget.pref.currentTube = int.parse(
                                            widget.pref.currentTubeNo.substring(widget.pref.currentTubeNo.indexOf('-') + 1));
                                        tubeAvail = true;
                                      }

                                      //setting the dimension display to visible or not
                                      if ((widget.pref.currentTube == 1) &&
                                          dimDrift) {
                                        displayDim = true;
                                      } else {
                                        displayDim = false;
                                      }

                                      clearForm();
                                      // MyUtils.updateTubeNumber(
                                      //     details, data, widget.pref, 'iSCs', qty);

                                      // remTubes =
                                      //     qty - widget.pref.currentTube + 1;

                                      setState(() {});

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
                      height: 80,
                      width: (width - 40) / 2,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: width * 0.20,
                            child: Text(
                              'Weld: Fail',
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
                                  weld = v;
                                });
                              },
                              value: weld,
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
              if (displayDim)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: (width - 40) / 2,
                        height: 80,
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10, top: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _dim,
                          focusNode: focusNodeIdDrift,
                          decoration: InputDecoration(
                            fillColor: ((goodIdDrift && _dim.text.isNotEmpty) ||
                                    (!_dim.text.isNotEmpty))
                                ? Colors.white
                                : Colors.red,
                            hintText: 'Drift Dimension:',
                            filled: true,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )),
                    Container(
                        width: (width - 40) / 2,
                        height: 80,
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10, top: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _dimInsp,
                          decoration: InputDecoration(
                            hintText: 'Inspector ID: ',
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
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  controller: _repair,
//                  readOnly: true,
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
                          'Inspection Notes: ${data['formData']['inspNotes'] ?? "--"}',
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
                          await validateIdDrift();

                          if ((_repair.text.isNotEmpty &&
                                  !isOdChecked &&
                                  !isLengthChecked &&
                                  weld) ||
                              (widget.pref.currentTube == 1 &&
                                      idDrift &&
                                      goodIdDrift) &&
                                  (_repair.text.isNotEmpty &&
                                      !isOdChecked &&
                                      !isLengthChecked &&
                                      weld)) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "insp_station_chksheet": {
                                  "tube_id": "${widget.pref.currentTubeNo}",
                                  "id_drift": idDrift ? "P" : "F",
                                  "od_check3": "${_odChecked.text}",
                                  "length_check2": "${_length.text}",
                                  "weld": weld ? "P" : "F",
                                  "repairs": "${_repair.text}",
                                  "inspector":
                                      "${widget.pref.userDetails.userId}"
                                  // "dim": "6",
                                  // "dimInsp": "${_dimInsp.text}",
                                }
                              }
                            };

                            Map<String, dynamic> map1 = {
                              "dimData": {
                                "dim": "${_dim.text}",
                                "dimInsp": "${_dimInsp.text}",
                                "job": data['formData']['job']
                              }
                            };
                            await api.postTubeData(map);
                            await api.postDimData(map1);
                            // setState(() {
                            //   tubesFinished++;
                            // });
                            //Update the api
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);

                            if (data['formData']['nextTubeInsp'] == "") {
                              tubeAvail = false;
                            } else {
                              //check if nextTube is an additional scrap tube to update remaining tubes
                              // if (int.parse(data['formData']['nextTubeInsp']
                              //         .substring(data['formData']
                              //                     ['nextTubeInsp']
                              //                 .indexOf('-') +
                              //             1)) <
                              //     widget.pref.currentTube) {
                              //   remTubes++;
                              // }

                              widget.pref.currentTubeNo =
                                  data['formData']['nextTubeInsp'];

                              widget.pref.currentTube = int.parse(
                                  widget.pref.currentTubeNo.substring(
                                      widget.pref.currentTubeNo.indexOf('-') +
                                          1));

                              // remTubes = qty - widget.pref.currentTube;

                              tubeAvail = true;
                            }

                            //setting the dimension display to visible or not
                            if ((widget.pref.currentTube == 1) && dimDrift) {
                              displayDim = true;
                            } else {
                              displayDim = false;
                            }

                            //ending job, check for excluder job and geoform job
                            if ((int.parse(data['tubesInsp']) == 0) &&
                                (int.parse(data['ringMax1']) == 0) &&
                                (int.parse(data['ringMax2']) == 0) &&
                                (int.parse(data['final_len_geo']) == 0)) {
                              Map<String, dynamic> endMap = {
                                "endData": {
                                  "endJob": 1,
                                  "job": '${widget.pref.jobId}',
                                }
                              };
                              await api.postEndJob(endMap);
                            }

                            clearForm();
                            setState(() {});

                            if (int.parse(data['tubesInsp']) == 0) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.jobScreen);
                            }
                            //initState();
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
    _idDrift.clear();
    dimDrift = false;
    displayDim = false;
    _dim.clear();
    _dimInsp.clear();
    _length.clear();
    _odChecked.clear();
    _weld.clear();
    _repair.clear();
    _reason.clear();
    idDrift = false;
    weld = false;
  }
}
