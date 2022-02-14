import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model_stamping.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/models/number_formating.dart';

class CycleCheckSheetForm extends StatefulWidget {
  final PreferencesService pref;

  CycleCheckSheetForm(this.pref, {Key key}) : super(key: key);

  @override
  CycleCheckSheetFormState createState() => CycleCheckSheetFormState();
}

class CycleCheckSheetFormState extends State<CycleCheckSheetForm> {
  TextEditingController _dimple1 = TextEditingController();
  TextEditingController _dimple2 = TextEditingController();
  TextEditingController _dimple3 = TextEditingController();
  TextEditingController _dimple4 = TextEditingController();
  TextEditingController _dimple5 = TextEditingController();
  TextEditingController _reason = TextEditingController();
  TextEditingController _remarks = TextEditingController();
  TextEditingController _hitCount = TextEditingController();
  TextEditingController _badStampLength = TextEditingController();
  TextEditingController _opID = TextEditingController();
  FocusNode focusNodeDimple1;
  FocusNode focusNodeDimple2;
  FocusNode focusNodeDimple3;
  FocusNode focusNodeDimple4;
  FocusNode focusNodeDimple5;
  FocusNode focusNodeOpID;
  bool issueDimple1 = false;
  bool issueDimple2 = false;
  bool issueDimple3 = false;
  bool issueDimple4 = false;
  bool issueDimple5 = false;
  bool issueAvgDimple = false;
  bool started = false;
  bool isCoil = false;
  bool isCycle = false;
  bool isCont = false;
  bool isScrap = false;
  bool isFirstTube = true;
  int totCycles = 0;
  int linFeet = 0;
  int hitCount = 0;
  String currentCycle = "";
  String nextTube = "";
  String lastCycle = "";

  List<Coils> coils = [];
  double height = 0;
  double width = 0;
  double stripWidth = 0;
  double avgDimple = 0;
  APICall api;
  Map<String, dynamic> data;
  @override
  void initState() {
    api = APICall();
    data = json.decode(widget.pref.jobData);
    setState(() {
      // determine if job is cycled or continous
      if (int.parse(data['linFeet']) == 0) {
        isCycle = true;
        String press = widget.pref.millName + 'Alt';
        if (int.parse(data[press]) > 0) {
          hitCount = int.parse(data[press]);
        } else {
          hitCount = int.parse(data[widget.pref.millName]);
        }
      } else {
        isCont = true;
        linFeet = int.parse(data['linFeet']);
        hitCount = 1000;
      }

      // setting strip width
      if (double.parse(data['stripWidthAlt']) > 0) {
        stripWidth = double.parse(data['stripWidthAlt']);
      } else {
        stripWidth = double.parse(data['stripWidth']);
      }

      // Checking if first cycle
      if (int.parse(data['complCycles']) != 0) {
        isFirstTube = false;
      }

      totCycles = int.parse(data['cycles']);

      //setting current cycle if its the first cycle
      if (data['currentCycle'] == "" && data['complCycles'] != totCycles) {
        currentCycle = generateCycleNumber();
      }
    });

    started = widget.pref.isOrderStarted;

    super.initState();
    double dimpleDepthP =
        double.parse(data['dimpleDepth']) + double.parse(data['dimpleDepthP']);
    double dimpleDepthM =
        double.parse(data['dimpleDepth']) - double.parse(data['dimpleDepthM']);
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Cycle Check Sheet')),
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
                        .pushReplacementNamed(Routes.dieSetupForm);
                  },
                  child: Text('Set-Up Sheet',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          if (data['coils'].length != 0)
            SizedBox(
              width: width,
              child: _cardCycleInfo(),
            ),
          if (data['complCycles'] != totCycles && data['coils'].length != 0)
            SizedBox(width: width * 0.97, child: orderStartedInfoCard()),
          SizedBox(
            height: 10,
          ),
          if ((int.parse(data['complCycles']) == totCycles) &&
              (totCycles != 0) &&
              data['coils'].length != 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: Text('No More Cycles',
                        style: bigFontStyle.copyWith(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 50,
                    width: width * .49,
                    child: RaisedButton(
                      color: secondaryColor,
                      onPressed: () async {
                        //Update the api
                        await api.getDataStamping(widget.pref);

                        setState(() {
                          data = json.decode(widget.pref.jobData);
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
          if ((int.parse(data['complCycles']) != totCycles) &&
              totCycles != 0 &&
              data['coils'].length != 0)
            cycleEditCard(generateCycleNumber()),
          if (data['coils'].length == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: Text('No Coils!',
                        style: bigFontStyle.copyWith(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 50,
                    width: width * .49,
                    child: RaisedButton(
                      color: secondaryColor,
                      onPressed: () async {
                        //Update the api
                        await api.getDataStamping(widget.pref);

                        setState(() {
                          data = json.decode(widget.pref.jobData);
                        });
                      },
                      child: Text('Refresh',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )
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
                        'Press Operator: ${widget.pref.userDetails.userName}',
                        style: bigFontStyle,
                      ),
                      Text(
                        'Cycles Remaining: ' +
                            (totCycles - int.parse(data['complCycles']))
                                .toString(),
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

  Widget _cardCycleInfo() {
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
                    'Stamping info',
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
                        child: Text('Job #: ${data['job']}',
                            style: bigBoldFontStyle.copyWith()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      if (isCycle)
                        SizedBox(
                          width: width * 0.45,
                          child: Text('Total Cycles: ' + totCycles.toString(),
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      if (isCont)
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Total Linear Feet: ' + linFeet.toString(),
                              style: bigBoldFontStyle.copyWith()),
                        )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.45,
                        child: Text('Hit Count: ' + hitCount.toString(),
                            style: bigBoldFontStyle.copyWith(fontSize: 22)),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                            'Current Coil #: ${data['coils'][0]['coil_no'] ?? "--"}',
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
                        width: width * 0.3,
                        child: Text('Die #:  ${data['die'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                            'Progression: ${data['progression'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text('Mat. Type: ${data['matType'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: Text('Gage:  ${data['gage'] ?? "--"}',
                            style: bigBoldFontStyle),
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text('Width: ' + stripWidth.toString(),
                            style: bigBoldFontStyle),
                      ),
                      if (double.parse(data['dimpleDepth']) != 0 &&
                          int.parse(data['is_louver']) == 0)
                        SizedBox(
                          width: width * 0.3,
                          child: Text(
                              'Dimple Depth: ${data['dimpleDepth'] ?? "--"}  ' +
                                  '+ ${data['dimpleDepthP'] ?? "--"} - ${data['dimpleDepthM'] ?? "--"}',
                              style: bigBoldFontStyle),
                        ),
                      if (double.parse(data['dimpleDepth']) != 0 &&
                          int.parse(data['is_louver']) == 1)
                        SizedBox(
                          width: width * 0.3,
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
          ],
        ),
      ),
    );
  }

  Widget cycleEditCard(String currentCycle) {
    if ((double.parse(data['dimpleDepth']) != 0 &&
            ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
            int.parse(data['complCycles']) != 0 &&
            avgDimple == 0) ||
        (isCont && double.parse(data['dimpleDepth']) != 0 && avgDimple == 0))
      issueAvgDimple = true;
    if (int.parse(data['complCycles']) != totCycles && totCycles != 0)
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
                          currentCycle,
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
                                    height: 250,
                                    width: 300,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 200,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: _badStampLength,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                                labelText: "Scrap Length (ft)"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 100,
                                          width: 200,
                                          child: TextField(
                                            controller: _reason,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                labelText:
                                                    "Reason for bad stamp"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    RaisedButton(
                                      onPressed: () async {
                                        await api.postBadStamp(
                                            widget.pref,
                                            currentCycle,
                                            _reason.text ?? "",
                                            data['coils'][0]['coil_no'] ?? "",
                                            _badStampLength.text ?? "");
                                        clearForm();

                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.green,
                                      child: Text('Bad Stamp'),
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
                          child: const Text('Bad Stamp',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCont && double.parse(data['dimpleDepth']) != 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.9,
                              child: Text('Enter every 1000 hits!',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _dimple1,
                      focusNode: focusNodeDimple1,
                      decoration: InputDecoration(
                        hintText: 'Dimple/Louver Depth Check ',
                        fillColor:
                            (issueDimple1) ? Colors.yellow : Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: (issueDimple1) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (issueDimple1)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Caution deep dimple',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _dimple2,
                      focusNode: focusNodeDimple2,
                      decoration: InputDecoration(
                        hintText: 'Dimple/Louver Depth Check ',
                        fillColor:
                            (issueDimple2) ? Colors.yellow : Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: (issueDimple2) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (issueDimple2)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Caution deep dimple',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _dimple3,
                      focusNode: focusNodeDimple3,
                      decoration: InputDecoration(
                        hintText: 'Dimple/Louver Depth Check ',
                        fillColor:
                            (issueDimple3) ? Colors.yellow : Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: (issueDimple3) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (issueDimple3)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Caution deep dimple',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _dimple4,
                      focusNode: focusNodeDimple4,
                      decoration: InputDecoration(
                        hintText: 'Dimple/Louver Depth Check ',
                        fillColor:
                            (issueDimple4) ? Colors.yellow : Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: (issueDimple4) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (issueDimple4)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Caution deep dimple',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _dimple5,
                      focusNode: focusNodeDimple5,
                      decoration: InputDecoration(
                        hintText: 'Dimple/Louver Depth Check ',
                        fillColor:
                            (issueDimple5) ? Colors.yellow : Colors.white,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: (issueDimple5) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (issueDimple5)
                  Container(
                    width: width * 0.9,
                    padding: EdgeInsets.only(left: 10.0, right: 10),
                    child: Text('Caution deep dimple',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.red)),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Container(
                    height: 80,
                    width: width * .45,
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: RaisedButton(
                      onPressed: () {
                        double dimp1 = double.parse(_dimple1.text ?? "0");
                        double dimp2 = double.parse(_dimple2.text ?? "0");
                        double dimp3 = double.parse(_dimple3.text ?? "0");
                        double dimp4 = double.parse(_dimple4.text ?? "0");
                        double dimp5 = double.parse(_dimple5.text ?? "0");
                        double avg = double.parse(
                            ((dimp1 + dimp2 + dimp3 + dimp4 + dimp5) / 5)
                                .toStringAsFixed(3));
                        if (avg >
                                (double.parse(data['dimpleDepth']) +
                                    double.parse(data['dimpleDepthP'])) ||
                            avg <
                                (double.parse(data['dimpleDepth']) -
                                    double.parse(data['dimpleDepthM']))) {
                          issueAvgDimple = true;
                        } else {
                          issueAvgDimple = false;
                        }
                        setState(() {});
                        avgDimple = avg;
                      },
                      child: Text(
                        'Calc Avg Dimple/Louver Depth',
                        style: bigBoldFontStyle,
                      ),
                    ),
                  ),
                if ((double.parse(data['dimpleDepth']) != 0 &&
                        ((int.parse(data['complCycles']) + 1) % 5 == 0) &&
                        int.parse(data['complCycles']) != 0) ||
                    (isCont && double.parse(data['dimpleDepth']) != 0))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (width - 40),
                        height: 50,
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10, top: 20),
                        child: Text("Average : $avgDimple",
                            style: TextStyle(
                                color: (issueAvgDimple)
                                    ? Colors.red
                                    : Colors.black,
                                fontSize: 25)),
                      ),
                    ],
                  ),
                Container(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10, bottom: 80, top: 80),
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
                                height: 200,
                                width: 250,
                                child: Column(
                                  children: [
                                    Text('Do you want to end current coil?',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    if (isCont)
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _hitCount,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            labelText:
                                                "Hit count of last 1000 hits"),
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                RaisedButton(
                                  onPressed: () async {
                                    isCoil = true;
                                    if (isCont && _hitCount.text.isNotEmpty) {
                                      Map<String, dynamic> map;
                                      if (int.parse(data['complCycles']) !=
                                          (totCycles - 1)) {
                                        map = {
                                          "endCoilData": {
                                            "press_op":
                                                "${widget.pref.userDetails.userId}",
                                            "job": '${widget.pref.jobId}',
                                            "cycle_id": currentCycle,
                                            "new_coil": isCoil ? 1 : 0,
                                            "hit_count": _hitCount.text,
                                            "progression":
                                                '${data['progression']}',
                                            "mill_job": '${data['millJob']}',
                                            "coil_no":
                                                '${data['coils'][0]['coil_no']}'
                                          }
                                        };
                                      } else {
                                        map = {
                                          "endCoilData": {
                                            "press_op":
                                                "${widget.pref.userDetails.userId}",
                                            "job": '${widget.pref.jobId}',
                                            "cycle_id": currentCycle,
                                            "new_coil": isCoil ? 1 : 0,
                                            "hit_count": _hitCount.text,
                                            "progression":
                                                '${data['progression']}',
                                            "mill_job": '${data['millJob']}',
                                            "coil_no":
                                                '${data['coils'][0]['coil_no']}',
                                            "endJob": "1"
                                          }
                                        };
                                      }
                                      await api.postEndCoilStamping(map);
                                      //Update the api
                                      await api.getDataStamping(widget.pref);
                                      data = json.decode(widget.pref.jobData);
                                      isCoil = false;

                                      setState(() {});
                                      if (int.parse(data['complCycles']) !=
                                          (totCycles - 1)) {
                                        Navigator.of(context).pop();
                                      } else {
                                        await api.endJobStamping(widget.pref);
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Routes.jobScreenStamping);
                                      }
                                    } else {
                                      if (!isCont) {
                                        Navigator.of(context).pop();
                                      }
                                    }
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
                      child: const Text('End Coil',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _opID,
                    focusNode: focusNodeOpID,
                    decoration: InputDecoration(
                      hintText: 'Operator ID ',
                      filled: false,
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
                            if (!issueAvgDimple && _opID.text.isNotEmpty) {
                              if (!isCont &&
                                  int.parse(data['complCycles']) ==
                                      (totCycles - 1)) {
                                isCoil = true;
                              }
                              Map<String, dynamic> map = {
                                "cycleData": {
                                  "press_op":
                                      "${widget.pref.userDetails.userId}",
                                  "job": '${widget.pref.jobId}',
                                  "cycle_id": currentCycle,
                                  "new_coil": isCoil ? 1 : 0,
                                  "coil_no": '${data['coils'][0]['coil_no']}',
                                  "dimple1": _dimple1.text,
                                  "dimple2": _dimple2.text,
                                  "dimple3": _dimple3.text,
                                  "dimple4": _dimple4.text,
                                  "dimple5": _dimple5.text,
                                  "dimpleAvg": avgDimple
                                }
                              };
                              await api.postCycleData(map);
                              lastCycle = currentCycle;
                              //Update the api
                              await api.getDataStamping(widget.pref);
                              data = json.decode(widget.pref.jobData);

                              setState(() {
                                currentCycle = generateCycleNumber();
                              });
                              //only clears form if the tube saved to the database
                              if (lastCycle == currentCycle) {
                                Flushbar(
                                  title: "Cycle didn't save",
                                  message: "Try exiting out of app",
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 6),
                                )..show(context);
                              } else {
                                clearForm();
                              }
                              if (int.parse(data['complCycles']) == totCycles &&
                                  totCycles != 0) {
                                await api.endJobStamping(widget.pref);
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.loginScreen);
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
    if (int.parse(data['complCycles']) == totCycles && totCycles != 0)
      return SizedBox(
        width: width * 0.97,
        child: Text('All Cycles Completed',
            style: bigFontStyle.copyWith(color: Colors.black)),
      );
  }

  String generateCycleNumber() {
    String ret = "";
    ret = widget.pref.jobId.toString() +
        '-' +
        (int.parse(data['complCycles']) + 1)
            .toString()
            .padLeft(totCycles.toString().length, "0");
    return ret;
  }

  clearForm() {
    isCoil = false;
    issueAvgDimple = false;
    issueDimple1 = false;
    issueDimple2 = false;
    issueDimple3 = false;
    issueDimple4 = false;
    issueDimple5 = false;
    avgDimple = 0;
    _reason.clear();
    _dimple1.clear();
    _dimple2.clear();
    _dimple3.clear();
    _dimple4.clear();
    _dimple5.clear();
    _remarks.clear();
    _opID.clear();
    _badStampLength.clear();
    _hitCount.clear();
  }
}
