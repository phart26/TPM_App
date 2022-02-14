import 'dart:convert';

import 'package:f_logs/f_logs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/coils_model_stamping.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class PressSetupForm extends StatefulWidget {
  final PreferencesService pref;
  PressSetupForm(this.pref, {Key key}) : super(key: key);
  @override
  _PressSetupFormState createState() => _PressSetupFormState();
}

class _PressSetupFormState extends State<PressSetupForm> {
  double height = 0;
  double width = 0;
  int isStarted = 0;
  bool isDataLoading = false;
  APICall apiCall = APICall();
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
          title: Text('Press Setup'),
        ),
        body: (isDataLoading)
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Container(
                width: width,
                child: Column(
                  children: [
                    _getJobCard(
                        data['job'], data['part'] ?? "--", data['die'] ?? "--"),
                    if (isStarted == 0) _getStartJobCard(),
                    if (isStarted == 1) _getStartedJobCard(),
                    if (isStarted == 2) _getDieInstructionSetup(),
                  ],
                ),
              ));
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
                    'Die $die',
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
                    onPressed: () async {
//                      Navigator.of(context).pushNamed(Routes.millInstSetup);
                      setState(() {
                        isStarted = 2;
                      });
                      await apiCall.postStartJob(widget.pref, "S");
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

  Widget _getDieInstructionSetup() {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      'Press Inspection Before Setup',
                      style: bigBoldFontStyle.copyWith(color: Colors.white),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('1. Clean around press ', style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('2. Check air lines ', style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('3. Check oiler ', style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('4. Check general condition of press ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                  ],
                ),
              ),
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
                      'Your responsibilities while running press:',
                      style: bigBoldFontStyle.copyWith(color: Colors.white),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('1. READ WORK ORDER IN FULL ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '2. Watch material for missing punches, equal borders and imperfections ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text('3. Keep up with cycles and footage ',
                        style: bigBoldFontStyle),
                    SizedBox(height: 5),
                    Text(
                        '4. Clean slugs from under die, off press and off ground ',
                        style: bigBoldFontStyle),
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
                                width: width * 0.45,
                                child: RaisedButton(
                                    onPressed: () {
                                      var coils = coilsFromJson(
                                              json.encode(data['coils'])) ??
                                          [];
                                      if (coils.length == 0) {
                                        Flushbar(
                                          title: "Coils data not available",
                                          message:
                                              "Add coils to job then restart app",
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        )..show(context);
                                      } else
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                Routes.dieSetupForm);
                                    },
                                    color: primaryColor,
                                    child: Text(
                                      'Ok',
                                      style: bigFontStyle.copyWith(
                                          color: Colors.white),
                                    )),
                              ),
                              SizedBox(
                                width: width * 0.45,
                                child: RaisedButton(
                                  color: secondaryColor,
                                  onPressed: () async {
                                    //Update the api
                                    await apiCall.getDataStamping(widget.pref);

                                    setState(() {
                                      data = json.decode(widget.pref.jobData);
                                    });
                                  },
                                  child: Text('Refresh',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
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
