import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'dart:math' as math;

class TestScreen extends StatefulWidget {
  final PreferencesService pref;
  TestScreen(this.pref, {Key key}) : super(key: key);
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController setSrcap = TextEditingController();
  TextEditingController setMillActualAngle = TextEditingController();
  TextEditingController setMillTableHeight = TextEditingController();
  TextEditingController setMillTablePosition = TextEditingController();
  FocusNode focusNodeSetSrcap;
  FocusNode focusNodeActualAngle;
  FocusNode focusNodeTableHeight;
  FocusNode focusNodeTablePosition;
  double height = 0;
  double width = 0;
  bool bendTestVal = false;
  bool driftTestVal = false;
  bool isActiveAngle = false;
  bool isActiveTableHeight = false;
  bool isActiveTablePosition = false;
  bool isLoading = false;

  @override
  void initState() {
    focusNodeSetSrcap = new FocusNode();
    focusNodeActualAngle = new FocusNode();
    focusNodeTableHeight = new FocusNode();
    focusNodeTablePosition = new FocusNode();

    isActiveAngle = false;
    isActiveTableHeight = false;
    isActiveTablePosition = false;
    isLoading = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text('Testing')),
        body: SingleChildScrollView(
          child: (isLoading) ?
          Container(
            padding: EdgeInsets.all(20),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 15),
                      Text('Please wait a moment...', style: bigBoldFontStyle.copyWith(),)
                    ],
                  )))
              :
          Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: width * 0.95, child: _getBendTestCard()),
                SizedBox(width: width * 0.95, child: _getDriftTestCard()),
                SizedBox(width: width * 0.95, child: _getScrapCard()),
                SizedBox(width: width * 0.95, child: _getMillReadings()),
                if (bendTestVal && driftTestVal && setSrcap.text.isNotEmpty)
                  SizedBox(
                    width: width * 0.9,
                    child: ElevatedButton(
                        onPressed: () async {
                          if(setMillActualAngle.text == null || setMillActualAngle.text == ""){
                             setState(() { isActiveAngle = true; });
                          }
                          if(setMillTableHeight.text == null || setMillTableHeight.text == ""){
                            setState(() {isActiveTableHeight = true;});
                          }
                          if(setMillTablePosition.text == null || setMillTablePosition.text == ""){
                            setState(() {isActiveTablePosition = true;});
                          }

                          if(!isActiveAngle && !isActiveTableHeight && !isActiveTablePosition){
                            setState(() { isLoading = true;});
                            Map<String, dynamic> millReadings = {"angle": setMillActualAngle.text, "height": setMillTableHeight.text, "position": setMillTablePosition.text};

                            await APICall().postTestResults(widget.pref);
                            await APICall().postScarp(widget.pref, "Setup Scrap", "", setSrcap.text ?? "", "S", millData: jsonEncode(millReadings));
                            await APICall().getData(widget.pref);

                            setState(() { isLoading = false;});
                            Navigator.of(context).pushReplacementNamed(Routes.weldingForm);
                          }
                        },
                        style: ButtonStyle( backgroundColor: MaterialStateProperty.all(primaryColor)),
                        child: Text(
                          'Ok',
                          style: bigFontStyle.copyWith(color: Colors.white),
                        )),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _getBendTestCard() {
    return Card(
        child: Column(
      children: [
        Container(
            height: 80,
            width: width * 0.95,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bend Test',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
        //body
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              RaisedButton(
                child: Text('Pass',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                onPressed: () {
                  setState(() {
                    bendTestVal = !bendTestVal;
                  });
                },
              ),
              SizedBox(
                width: width * 0.4,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.partMfgInfo);
                  },
                  child: Text(
                    'Fail',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 50,
            width: width * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: bendTestVal,
                child: Text(
                  "Bend Test Passed",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[800]),
                ),
              ),
            )),
      ],
    ));
  }

  Widget _getDriftTestCard() {
    return Card(
        child: Column(
      children: [
        Container(
            height: 80,
            width: width * 0.95,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Drift Test',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
        //body
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              RaisedButton(
                child: Text('Pass',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                onPressed: () {
                  setState(() {
                    driftTestVal = !driftTestVal;
                  });
                },
              ),
              SizedBox(
                width: width * 0.4,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.partMfgInfo);
                  },
                  child: Text(
                    'Fail',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 50,
            width: width * 0.95,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                visible: driftTestVal,
                child: Text(
                  "Drift Test Passed",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen[800]),
                ),
              ),
            )),
      ],
    ));
  }

  Widget _getScrapCard() {
    return Card(
        child: Column(
      children: [
        Container(
            // height: 80,
            width: width * 0.95,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Setup Scrap',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
        //body
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child:
                Container(
                  padding:
                  EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: setSrcap,
                    focusNode: focusNodeSetSrcap,
                    decoration: InputDecoration(
                      hintText: 'Length (in)',
                      fillColor: Colors.white,
                      filled: true,
                      border: new OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _getMillReadings() {
    return Card(
        child: Column(
      children: [
        Container(
            width: width * 0.95,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Mill Readings',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
        //body
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child:
                Container(
                  padding:
                  EdgeInsets.only(left: 0, right: 10, top: 0, bottom: 20),
                  child: TextFormField(
                    onChanged: (val) {
                      if(val=='' || val == null){
                        setState(() {isActiveAngle = true;});
                      }else{
                        setState(() {isActiveAngle = false;});
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: setMillActualAngle,
                    focusNode: focusNodeActualAngle,
                    decoration: InputDecoration(
                      labelText: 'Actual Angle',
                      hintText: '0.00',
                      fillColor: Colors.white,
                      errorText: isActiveAngle ? 'Can`t be empty' : null,
                      filled: true,
                    ),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child:
                Container(
                  padding:
                  EdgeInsets.only(left: 10.0, right: 10, top: 0, bottom: 20),
                  child: TextField(
                    onChanged: (val) {
                      if(val=='' || val == null){
                        setState(() {isActiveTableHeight = true;});
                      }else{
                        setState(() {isActiveTableHeight = false;});
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: setMillTableHeight,
                    focusNode: focusNodeTableHeight,
                    decoration: InputDecoration(
                      labelText: 'Table Height',
                      hintText: '0.00',
                      errorText: isActiveTableHeight ? 'Can`t be empty' : null,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              Expanded(
                child:
                Container(
                  padding:
                  EdgeInsets.only(left: 10.0, right: 0, top: 0, bottom: 20),
                  child: TextField(
                    onChanged: (val) {
                      if(val=='' || val == null){
                        setState(() {isActiveTablePosition = true;});
                      }else{
                        setState(() {isActiveTablePosition = false;});
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: setMillTablePosition,
                    focusNode: focusNodeTablePosition,
                    decoration: InputDecoration(
                      labelText: 'Table Position',
                      hintText: '0.00',
                      fillColor: Colors.white,
                      errorText: isActiveTablePosition ? "Can`t be empty" : null,
                      filled: true,
                    ),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

}
