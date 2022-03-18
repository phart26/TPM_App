import 'dart:convert';

import 'package:f_logs/f_logs.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model.dart';
import 'package:tpmapp/models/mesh_model.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class TubeMillSetupForm extends StatefulWidget {
  final PreferencesService pref;
  TubeMillSetupForm(this.pref, {Key key}) : super(key: key);
  @override
  _TubeMillSetupFormState createState() => _TubeMillSetupFormState();
}

class _TubeMillSetupFormState extends State<TubeMillSetupForm> {
  double height = 0;
  double width = 0;
  int isStarted = 0;
  bool isDataLoading = false;
  Map<String, dynamic> data;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    setState(() {
      isDataLoading = true;
    });
    APICall apiCall = APICall();
    await apiCall.getData(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
    });
    print(data);
    print(data['formData']);
    if (data['formData'] != null)
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
          title: Text('Tube Mill Setup'),
        ),
        body: (isDataLoading)
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Container(
                width: width,
                child: Column(
                  children: [
                    _getJobCard(
                        data['formData']['job'],
                        data['formData']['partNum'] ?? "--",
                        data['formData']['customer'] ?? "--"),
                    if (isStarted == 0) _getStartJobCard(),
                    if (isStarted == 1) _getStartedJobCard(),
                    if (isStarted == 2) _getMillInstructionSetup(),
                  ],
                ),
              ));
  }

  Widget _getJobCard(String job, String part, String customer) {
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
                    'Customer: $customer',
                    style: bigFontStyle.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _getStartedJobCard() {
    return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
          child: Card(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Operator: ${widget.pref.userDetails.userName}',
                        style: bigFontStyle),
                    // Text('My operator 1', style: bigBoldFontStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Started At: ', style: bigFontStyle),
                    Text('${widget.pref.jobStarted}', style: bigBoldFontStyle),
                  ],
                ),
              ),
              SizedBox(
                  width: width * 0.9,
                  child: RaisedButton(
                    onPressed: () {
//                      Navigator.of(context).pushNamed(Routes.millInstSetup);
                      setState(() {
                        isStarted = 2;
                      });
                    },
                    child: Text(
                      'Next',
                      style: bigFontStyle.copyWith(color: Colors.white),
                    ),
                    color: primaryColor,
                  ))
            ],
          )),
        ));
  }

  Widget _getStartJobCard() {
    return Container(
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
          child: Card(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Operator: ${widget.pref.userDetails.userName}',
                        style: bigFontStyle),
                    //Text('My operator 1', style: bigBoldFontStyle),
                  ],
                ),
              ),
              SizedBox(
                  width: width * 0.9,
                  child: RaisedButton(
                    onPressed: () {
                      widget.pref.jobStarted = DateFormat('dd-MM-yyyy hh:mm a')
                          .format(DateTime.now());
                      setState(() {
                        isStarted = 1;
                      });
                    },
                    child: Text(
                      'Start',
                      style: bigFontStyle.copyWith(color: Colors.white),
                    ),
                    color: primaryColor,
                  ))
            ],
          )),
        ));
  }

  Widget _getMillInstructionSetup() {
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
                      'Mill Inspection before setup',
                      style: bigBoldFontStyle.copyWith(color: Colors.white),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('1. Clean mill table and area ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('2. Receive setup paperwork ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('3. Check steel for straightness ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('4. Inspect die and clamps ', style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('5. Check level of front plate  ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('6. Check that table is level ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '7. Check that all chains, adjustment nuts, and bolts are tight',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '8. Use the proper shoot and shim as per paperwork (last setup) ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('9. Fill out pre-startup check sheet',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('10. If needed, get a second opinion',
                        style: bigBoldFontStyle),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
//                    SizedBox(height: 5),
//                    Text('Mill Inspection before setup',
//                        style: bigBoldFontStyle.copyWith(fontSize: 25)),
                    // SizedBox(height: 5),
                    // Text(
                    //     data['formData']['inspNotes'] ??
                    //         'MAX OD: 7.310\" Must drift with 6.979 +0.010\" drift. \nBlank ends tolerance must be within 2.7\" +\/-0.30\ ',
                    //     style: bigBoldFontStyle),
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
                                    onPressed: () {
                                      var coils = coilsFromJson(json.encode(data['formData']['coils'])) ?? [];
                                      var meshs = meshsFromJson(json.encode(data['formData']['mesh'])) ?? [];
                                      if (coils.length == 0) {
                                        Flushbar(
                                          title:
                                              "Coils or Mesh data not available",
                                          message:
                                              "Please add coils to job then start again the app",
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        )..show(context);
                                      } else
                                        Navigator.of(context).pushReplacementNamed(Routes.partMfgInfo);
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
                                      setState(() {
                                        isStarted = 0;
                                      });
                                    },
                                    color: secondaryColor,
                                    child: Text(
                                      'Start again',
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
}
