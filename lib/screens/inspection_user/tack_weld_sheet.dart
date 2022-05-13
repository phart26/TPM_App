import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/models/number_formating.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:fraction/fraction.dart';

class TackWeldSheet extends StatefulWidget {
  final PreferencesService pref;

  TackWeldSheet(this.pref, {Key key}) : super(key: key);
  @override
  _TackWeldSheetState createState() => _TackWeldSheetState();
}

class _TackWeldSheetState extends State<TackWeldSheet> {
  bool tubeAvail = false;
  int tubesFinished = 0;
  double height = 0;
  double width = 0;
  int remTubes = 0;
  int qty = 0;
  Map<String, dynamic> data;
  TextEditingController _fromTube = TextEditingController();
  TextEditingController _toTube = TextEditingController();
  APICall api;
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

      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    // check if tubes to tac
    if (int.parse(data['tubesTac']) > 0) tubeAvail = true;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tack Weld Sheet'),
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
                      ],
                    ),
                  ],
                ),
              ),
              _inspectionInfo(),
//              SizedBox(height: 8),
              orderInfoCard(),
              if (tubeAvail) tubeEditCard(widget.pref.jobId),
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
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Tubes remaining: ' + data['tubesTac'].toString(),
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
                        '$title' + ' - Tack Weld Tube Entry Form',
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: (width - 40) / 3,
                    height: 80,
                    padding: EdgeInsets.only(left: 50, top: 20),
                    child: TextField(
                      controller: _fromTube,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        hintText: 'From',
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
                    padding: EdgeInsets.only(right: 50, top: 20),
                    child: TextField(
                      controller: _toTube,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        hintText: 'To',
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
                          if ((_fromTube.text.isNotEmpty && _toTube.text.isNotEmpty)) {
                            Map<String, dynamic> map = {
                              "tubeData": {
                                "tack_weld_checksheet": {
                                  "tube_id_from": "${_fromTube.text}",
                                  "tube_id_to": "${_toTube.text}",
                                  "job": "${widget.pref.jobId}",
                                  "tack_weld_insp":
                                      "${widget.pref.userDetails.userId}"
                                }
                              }
                            };
                            // post entered data
                            await api.postTubeData(map);

                            // update the api
                            await api.getData(widget.pref);
                            data = json.decode(widget.pref.jobData);

                            clearForm();
                            // setState(() {});

                            //check if tack_weld job is finished
                            if (int.parse(data['tubesTac']) == 0) {
                              Map<String, dynamic> endMap = {
                                "endData": {
                                  "endJob": 1,
                                  "tackWeld": 1,
                                  "job": '${widget.pref.jobId}',
                                }
                              };
                              await api.postEndJob(endMap);
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
    tubeAvail = false;
    _fromTube.clear();
    _toTube.clear();
  }
}
