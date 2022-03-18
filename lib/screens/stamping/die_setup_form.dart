import 'dart:convert';

import 'package:f_logs/f_logs.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model_stamping.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/models/number_formating.dart';

class DieSetupForm extends StatefulWidget {
  final PreferencesService pref;
  DieSetupForm(this.pref, {Key key}) : super(key: key);
  @override
  _DieSetupFormState createState() => _DieSetupFormState();
}

class _DieSetupFormState extends State<DieSetupForm> {
  TextEditingController _dimple1 = TextEditingController();
  TextEditingController _dimple2 = TextEditingController();
  TextEditingController _dimple3 = TextEditingController();
  TextEditingController _dimple4 = TextEditingController();
  TextEditingController _dimple5 = TextEditingController();
  FocusNode focusNodeDimple1;
  FocusNode focusNodeDimple2;
  FocusNode focusNodeDimple3;
  FocusNode focusNodeDimple4;
  FocusNode focusNodeDimple5;
  bool issueDimple1 = false;
  bool issueDimple2 = false;
  bool issueDimple3 = false;
  bool issueDimple4 = false;
  bool issueDimple5 = false;
  double height = 0;
  double width = 0;
  int isStarted = 0;
  bool isDataLoading = false;
  Map<String, dynamic> data;
  APICall apiCall = APICall();
  @override
  void initState() {
    data = json.decode(widget.pref.jobData);
    setState(() {});
    super.initState();
    if (double.parse(data['dimpleDepth']) > 0) {
      double dimpleDepthP = double.parse(data['dimpleDepth']) +
          double.parse(data['dimpleDepthP']);
      double dimpleDepthM = double.parse(data['dimpleDepth']) -
          double.parse(data['dimpleDepthM']);
      focusNodeDimple1 = new FocusNode();
      focusNodeDimple1.addListener(() {
        if (!focusNodeDimple1.hasFocus) {
          if (_dimple1.text.isNotEmpty) {
            double val = 0;
            try {
              val = double.parse(_dimple1.text ?? "0");
            } on FormatException {
              val = 0;
            }
            if (val < NumberFormatter.roundDouble(dimpleDepthM, 3) ||
                val > NumberFormatter.roundDouble(dimpleDepthP, 3)) {
              setState(() {
                issueDimple1 = true;
              });
            } else {
              setState(() {
                issueDimple1 = false;
              });
            }
          }
        }
      });
      focusNodeDimple2 = new FocusNode();
      focusNodeDimple2.addListener(() {
        if (!focusNodeDimple2.hasFocus) {
          if (_dimple2.text.isNotEmpty) {
            double val = 0;
            try {
              val = double.parse(_dimple2.text ?? "0");
            } on FormatException {
              val = 0;
            }
            if (val < NumberFormatter.roundDouble(dimpleDepthM, 3) ||
                val > NumberFormatter.roundDouble(dimpleDepthP, 3)) {
              setState(() {
                issueDimple2 = true;
              });
            } else {
              setState(() {
                issueDimple2 = false;
              });
            }
          }
        }
      });
      focusNodeDimple3 = new FocusNode();
      focusNodeDimple3.addListener(() {
        if (!focusNodeDimple3.hasFocus) {
          if (_dimple3.text.isNotEmpty) {
            double val = 0;
            try {
              val = double.parse(_dimple3.text ?? "0");
            } on FormatException {
              val = 0;
            }
            if (val < NumberFormatter.roundDouble(dimpleDepthM, 3) ||
                val > NumberFormatter.roundDouble(dimpleDepthP, 3)) {
              setState(() {
                issueDimple3 = true;
              });
            } else {
              setState(() {
                issueDimple3 = false;
              });
            }
          }
        }
      });
      focusNodeDimple4 = new FocusNode();
      focusNodeDimple4.addListener(() {
        if (!focusNodeDimple4.hasFocus) {
          if (_dimple4.text.isNotEmpty) {
            double val = 0;
            try {
              val = double.parse(_dimple4.text ?? "0");
            } on FormatException {
              val = 0;
            }
            if (val < NumberFormatter.roundDouble(dimpleDepthM, 3) ||
                val > NumberFormatter.roundDouble(dimpleDepthP, 3)) {
              setState(() {
                issueDimple4 = true;
              });
            } else {
              setState(() {
                issueDimple4 = false;
              });
            }
          }
        }
      });
      focusNodeDimple5 = new FocusNode();
      focusNodeDimple5.addListener(() {
        if (!focusNodeDimple5.hasFocus) {
          if (_dimple5.text.isNotEmpty) {
            double val = 0;
            try {
              val = double.parse(_dimple5.text ?? "0");
            } on FormatException {
              val = 0;
            }
            if (val < NumberFormatter.roundDouble(dimpleDepthM, 3) ||
                val > NumberFormatter.roundDouble(dimpleDepthP, 3)) {
              setState(() {
                issueDimple5 = true;
              });
            } else {
              setState(() {
                issueDimple5 = false;
              });
            }
          }
        }
      });
    }
  }

  Future<void> loadData() async {
    setState(() {
      isDataLoading = true;
    });

    await apiCall.getDataStamping(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
    });
    if (data['job'] != null)
      FLog.info(text: "data loaded for ${widget.pref.jobId}");
    else
      FLog.error(text: "data not loaded for ${widget.pref.jobId}");
    FLog.exportLogs();
  }

  @override
  Widget build(BuildContext context) {
    print('pref val ${widget.pref.jobId}');
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Die Setup'),
        ),
        body: SingleChildScrollView(
            child: Container(
          width: width,
          child: Column(
            children: [
              _getJobCard(
                  data['job'], data['part'] ?? "--", data['die'] ?? "--"),
              _getDieInstructionSetup(),
            ],
          ),
        )));
  }

  Widget _getJobCard(String job, String part, String die) {
    return Container(
      width: width,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
          child: Card(
            color: secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job #$job',
                    style: bigFontStyle.copyWith(
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'Part #$part',
                    style: bigFontStyle.copyWith(color: primaryColor),
                  ),
                  Text(
                    'Die: $die',
                    style: bigFontStyle.copyWith(color: primaryColor),
                  ),
                  if (double.parse(data['dimpleDepth']) > 0 &&
                      int.parse(data['is_louver']) == 0)
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.9,
                          child: Text(
                              'Dimple Depth: ${data['dimpleDepth'] ?? "--"}  ' +
                                  '+ ${data['dimpleDepthP'] ?? "--"} - ${data['dimpleDepthM'] ?? "--"}',
                              style: bigBoldFontStyle),
                        )
                      ],
                    ),
                  if (double.parse(data['dimpleDepth']) > 0 &&
                      int.parse(data['is_louver']) == 1)
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.9,
                          child: Text(
                              'Louver Depth: ${data['dimpleDepth'] ?? "--"}  ' +
                                  '+ ${data['dimpleDepthP'] ?? "--"} - ${data['dimpleDepthM'] ?? "--"}',
                              style: bigBoldFontStyle),
                        )
                      ],
                    ),
                ],
              ),
            ),
          )),
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

  Widget _getDieInstructionSetup() {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
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
                      'Die setup',
                      style: bigBoldFontStyle.copyWith(color: Colors.white),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('1. Clean and rock ram and bolster ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '2. Clean and rock the top, bottom of die and parallels ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '3. Measure clearance between ram and bolster with ram on bottom of stroke ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('4. Measure die to see if its the same as step #3 ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('5. Move ram to top of stroke then set die in  ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('6. Square die then bring ram down ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('7. Must have no less than 4 clamps on top and bottom',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('8. Once done with clamping check square again ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('9. Feed in material then check square of material',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    if (data['testCycles'] == "1")
                      Text('10. Run 3 test cycles!',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(' Remarks: ' + data['remarks'],
                        style: bigBoldFontStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    if (data['coils'].length != 0)
                      Text(
                          'CURRENT COIL SELECTED: ' +
                              data['coils'][0]['coil_no'] +
                              '    HEAT #: ' +
                              data['coils'][0]['heat'],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    if (data['coils'].length == 0)
                      Text('NO COILS ALLOCATED!',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                  ],
                ),
              ),
              if (double.parse(data['dimpleDepth']) > 0)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _dimple1,
                    focusNode: focusNodeDimple1,
                    decoration: InputDecoration(
                      hintText: 'Dimple/Louver Depth Check ',
                      fillColor: (issueDimple1) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (issueDimple1) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (issueDimple1)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Dimple/Louver out of tolerance',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              if (double.parse(data['dimpleDepth']) > 0)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _dimple2,
                    focusNode: focusNodeDimple2,
                    decoration: InputDecoration(
                      hintText: 'Dimple/Louver Depth Check ',
                      fillColor: (issueDimple2) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (issueDimple2) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (issueDimple2)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Dimple/Louver out of tolerance',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              if (double.parse(data['dimpleDepth']) > 0)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _dimple3,
                    focusNode: focusNodeDimple3,
                    decoration: InputDecoration(
                      hintText: 'Dimple/Louver Depth Check ',
                      fillColor: (issueDimple3) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (issueDimple3) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (issueDimple3)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Dimple/Louver out of tolerance',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              if (double.parse(data['dimpleDepth']) > 0)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _dimple4,
                    focusNode: focusNodeDimple4,
                    decoration: InputDecoration(
                      hintText: 'Dimple/Louver Depth Check ',
                      fillColor: (issueDimple4) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (issueDimple4) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (issueDimple4)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Dimple/Louver out of tolerance',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              if (double.parse(data['dimpleDepth']) > 0)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _dimple5,
                    focusNode: focusNodeDimple5,
                    decoration: InputDecoration(
                      hintText: 'Dimple/Louver Depth Check ',
                      fillColor: (issueDimple5) ? Colors.red : Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: new BorderSide(
                          color: (issueDimple5) ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              if (issueDimple5)
                Container(
                  width: width * 0.9,
                  padding: EdgeInsets.only(left: 10.0, right: 10),
                  child: Text('Dimple/Louver out of tolerance',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.red)),
                ),
              if (double.parse(data['dimpleDepth']) > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50,
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: width * 0.3,
                                child: RaisedButton(
                                    onPressed: () async {
                                      var coils = coilsFromJson(
                                              json.encode(data['coils'])) ??
                                          [];
                                      if (coils.length == 0) {
                                        Flushbar(
                                          title: "Coil data not available",
                                          message:
                                              "Please add coils to job then refresh the app",
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        )..show(context);
                                      } else {
                                        if (!issueDimple1 &&
                                            !issueDimple2 &&
                                            !issueDimple3 &&
                                            !issueDimple4 &&
                                            !issueDimple5) {
                                          Map<String, dynamic> map = {
                                            "setupData": {
                                              "setup_op":
                                                  "${widget.pref.userDetails.userId}",
                                              "job": '${widget.pref.jobId}',
                                              "dimple1": _dimple1.text,
                                              "dimple2": _dimple2.text,
                                              "dimple3": _dimple3.text,
                                              "dimple4": _dimple4.text,
                                              "dimple5": _dimple5.text
                                            }
                                          };
                                          await apiCall.postSetupOp(map);
                                          clearForm();
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  Routes.cycleForm);
                                        } else {
                                          displayMessage();
                                        }
                                      }
                                    },
                                    color: primaryColor,
                                    child: Text(
                                      'Ok',
                                      style: bigFontStyle.copyWith(
                                          color: Colors.white),
                                    )),
                              ),
                              SizedBox(
                                width: width * 0.3,
                                child: RaisedButton(
                                    onPressed: () {
                                      loadData();
                                    },
                                    color: secondaryColor,
                                    child: Text(
                                      'Refresh',
                                      style: bigFontStyle,
                                    )),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearForm() {
    issueDimple1 = false;
    issueDimple2 = false;
    issueDimple3 = false;
    issueDimple4 = false;
    issueDimple5 = false;
    _dimple1.clear();
    _dimple2.clear();
    _dimple3.clear();
    _dimple4.clear();
    _dimple5.clear();
  }
}
