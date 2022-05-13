import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/store/job_list_store.dart';

class ModeSelectionScreen extends StatefulWidget {
  final PreferencesService pref;
  ModeSelectionScreen(this.pref, {Key key}) : super(key: key);

  @override
  _ModeSelectionScreenState createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  int notifyCount = 0;

  BuildContext buildContext;
  @override
  void initState() {
    getMillDetails();
    super.initState();
  }

  void getMillDetails() {
    APICall api = APICall();
    api.getMillList(widget.pref);
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      body: Container(
          color: secondaryColor,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                margin: EdgeInsets.only(bottom: 5,left:30,right:30),
                padding: EdgeInsets.only(left:10,right:10),
                child: Image.asset("assets/icon/logo.png"),
              ),
              SizedBox( height: 10 ),
              widget.pref.millName == ""
                  ? Text('Device not connected')
                  : Text(
                      'This device is connected with :${widget.pref.millName}'),
              SizedBox( height: 10 ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  if (widget.pref.millName == "") {
                    Flushbar(
                      title: "Device not connected",
                      message: "Please select device first",
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    )..show(context);
                  } else {
                    widget.pref.mode = 1;
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.loginScreen);
                  }
                },
                child: Text('Mill operator mode', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  widget.pref.mode = 2;
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: Text('Inspection user mode', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(230, 40),
                  maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  widget.pref.mode = 4;
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: Text('GeoForm mode', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  widget.pref.mode = 3;
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: Text('Mesh jobs mode', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  widget.pref.mode = 5;
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: Text('Stamping mode', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  widget.pref.mode = 6;
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.loginScreen);
                },
                child: Text('Steel Receiving', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(230, 40),
                    maximumSize: const Size(250, 40)
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.deviceSetupScreen);
                },
                child: Text('Setup Device', style: bigBoldFontStyle),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ))),
    );
  }
}
