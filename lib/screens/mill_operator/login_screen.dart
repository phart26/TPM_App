import 'package:device_info/device_info.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final PreferencesService pref;
  LoginScreen(this.pref, {Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userid = TextEditingController();
  double height = 0;
  bool isChecking = false;
  APICall api;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (isChecking)
              ? Container(
                  child: Center(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Please wait we are fetching data...')
                  ],
                )))
              : ListView(
                  children: [
                    SizedBox(
                      height: height * 0.5 - 80,
                    ),
                    if (widget.pref.mode == 1)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'Login Mill user',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    if (widget.pref.mode == 2)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'Login Inpsection user',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    if (widget.pref.mode == 3)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'Login Mesh user',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    if (widget.pref.mode == 4)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'GeoForm user',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    if (widget.pref.mode == 5)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'Login Stamping user',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    if (widget.pref.mode == 6)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                        child: Text(
                          'Login Steel Receiving',
                          style: bigBoldFontStyle.copyWith(
                              color: primaryColor, fontSize: 30),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                      child: TextField(
                        controller: _userid,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          labelText: 'Username',
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 8),
                      child: RaisedButton(
                        color: primaryColor,
                        onPressed: () async {
                          if (_userid.text.isEmpty)
                            Flushbar(
                              title: "Empty field",
                              message: "Please enter User ID",
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            )..show(context);
                          else {
                            setState(() {
                              isChecking = true;
                            });
                            await APICall().getJSONToken(widget.pref, _userid.text);
                            setState(() {
                              isChecking = false;
                            });
                            print('widget.pref.userDetails ${widget.pref.userDetails}');
                            if (widget.pref.userDetails != null) {
                              // mill user
                              if (widget.pref.mode == 1) {
                                Navigator.of(context).pushReplacementNamed(
                                    Routes.jobWaitingScreen);
                                // inspection user
                              } else if (widget.pref.mode == 2) {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.jobScreen);
                                //mesh user
                              } else if (widget.pref.mode == 3) {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.jobScreenMesh);
                                // GeoForm User
                              } else if (widget.pref.mode == 4) {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.jobScreenGeo);
                                //stamping
                              } else if (widget.pref.mode == 5) {
                                Navigator.of(context).pushReplacementNamed(
                                    Routes.jobScreenStamping);
                                //steel receiving
                              } else {
                                Navigator.of(context).pushReplacementNamed(
                                    Routes.jobScreenSteelReceiving);
                              }
                            } else {
                              Flushbar(
                                title: "Invalid user",
                                message: "User ID does not exist",
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: bigBoldFontStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      )),
    );
  }
}
