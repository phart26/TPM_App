import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:fraction/fraction.dart';

class RingStationCheckSheet extends StatefulWidget {
  final PreferencesService pref;

  RingStationCheckSheet(this.pref, {Key key}) : super(key: key);
  @override
  _RingStationCheckSheetState createState() => _RingStationCheckSheetState();
}

class _RingStationCheckSheetState extends State<RingStationCheckSheet> {
  bool isEndOne = false;
  bool isEndTwo = false;
  double height = 0;
  double width = 0;
  int qty = 0;
  Map<String, dynamic> data;
  bool isDataLoading = false;
  bool tubeAvail = false;
  double minRing = 0;
  double maxRing = 0;
  double avgOne = 0;
  double avgTwo = 0;
  TextEditingController _endOneF = TextEditingController();
  TextEditingController _endOneS = TextEditingController();
  TextEditingController _endTwoF = TextEditingController();
  TextEditingController _endTwoS = TextEditingController();
  TextEditingController _reason = TextEditingController();

  APICall api;
  @override
  void initState() {
    // TODO: implement initState
    api = APICall();
    setState(() {
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity']);
    });

    //set ring min and max od
    if (data['formData']['ringMin1'] != "0") {
      minRing = double.parse(data['formData']['ringMin1'] ?? "0");
      maxRing = double.parse(data['formData']['ringMax1'] ?? "0");
    } else if (data['formData']['ringMin2'] != "0") {
      minRing = double.parse(data['formData']['ringMin2'] ?? "0");
      maxRing = double.parse(data['formData']['ringMax2'] ?? "0");
    } else {
      minRing = 0;
      maxRing = 0;
    }

    // checking if tube is availabe on intial build
    if (data['formData']['nextTubeExcl'] != "") {
      widget.pref.currentTubeNo = data['formData']['nextTubeExcl'];
      widget.pref.currentTube = int.parse(widget.pref.currentTubeNo
          .substring(widget.pref.currentTubeNo.indexOf('-') + 1));
      setState(() {
        tubeAvail = true;
      });
    } else {
      widget.pref.currentTube = 0;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set endTwo to true if there is only one ring to be entered
    if (data['formData']['ringMin2'] == "0") isEndTwo = true;

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ring Station - Check Sheet'),
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

                                  if (data['formData']['nextTubeExcl'] == "") {
                                    tubeAvail = false;
                                  } else {
                                    widget.pref.currentTubeNo =
                                        data['formData']['nextTubeExcl'];

                                    widget.pref.currentTube = int.parse(widget
                                        .pref.currentTubeNo
                                        .substring(widget.pref.currentTubeNo
                                                .indexOf('-') +
                                            1));

                                    tubeAvail = true;
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
              _inspectionInfo(),
//              SizedBox(height: 8),
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
                              'Part Description: ${data['formData']['partDesc'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Average Ring ID: ' +
                                  minRing.toString() +
                                  ' To ' +
                                  maxRing.toString(),
                              style: bigBoldFontStyle.copyWith()),
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
                  if (data['formData']['ringMin2'] != "0")
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        'Rings remaining: ' +
                            (((int.parse(data['formData']['quantity']) -
                                            int.parse(data['formData']
                                                    ['nextTubeExcl']
                                                .substring(data['formData']
                                                            ['nextTubeExcl']
                                                        .indexOf('-') +
                                                    1))) *
                                        2) +
                                    2)
                                .toString(),
                        style: bigFontStyle,
                      ),
                    ),
                  if (data['formData']['ringMin1'] != "0")
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        'Rings remaining: ' +
                            (int.parse(data['formData']['quantity']) -
                                    int.parse(data['formData']['nextTubeExcl']
                                        .substring(data['formData']
                                                    ['nextTubeExcl']
                                                .indexOf('-') +
                                            1)))
                                .toString(),
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
              if ((double.parse(data['formData']['ringMin1']) > 0) ||
                  (double.parse(data['formData']['ringMin2']) > 0))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (width - 40) / 3,
                      height: 80,
                      padding: EdgeInsets.only(left: 10.0, top: 20),
                      child: TextField(
                        controller: _endOneF,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintText: 'End 1 Reading 1',
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
                      width: (width - 40) / 3,
                      padding: EdgeInsets.only(left: 10.0, top: 20),
                      child: TextField(
                        controller: _endOneS,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintText: 'End 1 Reading 2',
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
                      width: (width - 40) / 3,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: RaisedButton(
                        onPressed: () {
                          double x = double.parse(_endOneF.text ?? "0");
                          double y = double.parse(_endOneS.text ?? "0");
                          double avg =
                              double.parse(((x + y) / 2).toStringAsFixed(3));
                          print('from 1 $maxRing $minRing $avg');
                          if (avg > maxRing || avg < minRing) {
                            isEndOne = false;
                          } else {
                            isEndOne = true;
                          }
                          avgOne = avg;
                          setState(() {});
                        },
                        child: Text(
                          'End 1 Reading',
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              if ((double.parse(data['formData']['ringMin1']) > 0) ||
                  (double.parse(data['formData']['ringMin2']) > 0))
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (width - 40),
                      height: 50,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Text("Average : $avgOne",
                          style: TextStyle(
                              color: (isEndOne) ? Colors.black : Colors.red,
                              fontSize: 25)),
                    ),
                  ],
                ),
              if (double.parse(data['formData']['ringMin2']) > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (width - 40) / 3,
                      height: 80,
                      padding: EdgeInsets.only(left: 10.0, top: 10),
                      child: TextField(
                        controller: _endTwoF,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintText: 'End 2 Reading 1',
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
                      width: (width - 40) / 3,
                      padding: EdgeInsets.only(left: 10.0, top: 10),
                      child: TextField(
                        controller: _endTwoS,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintText: 'End 2 Reading 2',
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
                      width: (width - 40) / 3,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: RaisedButton(
                        onPressed: () {
                          double x = double.parse(_endTwoF.text ?? "0");
                          double y = double.parse(_endTwoS.text ?? "0");
                          double avg =
                              double.parse(((x + y) / 2).toStringAsFixed(3));
                          print('from 2 $maxRing $minRing $avg');
                          if (avg > maxRing || avg < minRing) {
                            isEndTwo = false;
                          } else {
                            isEndTwo = true;
                          }
                          avgTwo = avg;
                          setState(() {});
                        },
                        child: Text(
                          'End 2 Reading',
                          style: bigBoldFontStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              if (double.parse(data['formData']['ringMin2']) > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (width - 40),
                      height: 80,
                      padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                      child: Text(
                        "Average : $avgTwo",
                        style: TextStyle(
                            color: (isEndTwo) ? Colors.black : Colors.red,
                            fontSize: 25),
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
                      Text('All Ends Must be Checked with Calipers',
                          style: bigFontStyle.copyWith(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Text(
                            '-The tube will be checked in two places on each end of the tube, and average of two measurements must be within the average listed above.',
                            style: bigFontStyle.copyWith(fontSize: 17)),
                      ),
                      SizedBox(height: 10),
                      Text('Setup', style: bigFontStyle.copyWith(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        child: Text(
                            '-Setup ring ID to the lower range of the average tolerance.',
                            style: bigFontStyle.copyWith(fontSize: 17)),
                      ),
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
                          if (isEndOne && isEndTwo) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "ring_station_chksheet": {
                                  "tube_id": "${widget.pref.currentTubeNo}",
                                  "end1_read1": "${_endOneF.text}",
                                  "end1_read2": "${_endOneS.text}",
                                  "end1_avg": "$avgOne",
                                  "end2_read1": "${_endTwoF.text}",
                                  "end2_read2": "${_endTwoS.text}",
                                  "end2_avg": "$avgTwo",
                                  "ring_end_insp":
                                      "${widget.pref.userDetails.userId}"
                                }
                              }
                            };
                            // post entered data
                            await api.postTubeData(map);

                            // update the api
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);

                            if (data['formData']['nextTubeExcl'] == "") {
                              tubeAvail = false;
                            } else {
                              widget.pref.currentTubeNo =
                                  data['formData']['nextTubeExcl'];

                              widget.pref.currentTube = int.parse(
                                  widget.pref.currentTubeNo.substring(
                                      widget.pref.currentTubeNo.indexOf('-') +
                                          1));

                              tubeAvail = true;
                            }

                            clearForm();
                            setState(() {});
                            //check if excluder job is finished
                            if (int.parse(data['tubesExcl']) == 0) {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.jobScreen);
                            }
                            Flushbar(
                              title: "Ring Data Saved",
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
//                    SizedBox(
//                      height: 50,
//                      width: width * 0.45,
//                      child: RaisedButton(
//                        color: secondaryColor,
//                        onPressed: () {},
//                        child: const Text('Scrap',
//                            style: TextStyle(
//                                fontSize: 20, fontWeight: FontWeight.bold)),
//                      ),
//                    ),
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
    isEndOne = false;
    isEndTwo = false;
    avgOne = 0;
    avgTwo = 0;
    _reason.clear();
    _endOneF.clear();
    _endOneS.clear();
    _endTwoF.clear();
    _endTwoS.clear();
  }
}
