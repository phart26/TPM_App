import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/services/preferences_service.dart';

class DirectPackInspectionScreen extends StatefulWidget {
  final PreferencesService pref;

  DirectPackInspectionScreen(this.pref, {Key key}) : super(key: key);
  @override
  _DirectPackInspectionScreenState createState() =>
      _DirectPackInspectionScreenState();
}

class _DirectPackInspectionScreenState
    extends State<DirectPackInspectionScreen> {
  TextEditingController _tubeLength = TextEditingController();
  TextEditingController _shuntTubeLength = TextEditingController();
  TextEditingController _stp = TextEditingController();
  TextEditingController _idDrift = TextEditingController();
  TextEditingController _endGage = TextEditingController();

  double height = 0;
  double width = 0;
  Map<String, dynamic> data;
  bool isDataLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isDataLoading = true;
    });
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
      if (data != null) _tubeLength.text = data['formData'][''];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Pack Inspection'),
      ),
      body: (isDataLoading)
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    _inspectionInfo(),
//              SizedBox(height: 8),
                    orderInfoCard(),
                    tubeEditCard(widget.pref.currentTubeNo),
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
                    'Inspection info',
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
                              'Cutoff:  ${data['formData']['cutoffLength'] ?? '--'}  +${data['formData']['cutoffLengthP'] ?? '--'}  +${data['formData']['cutoffLengthM'] ?? '--'}',
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
                              'ID Drift:  ${data['formData']['idDrift'] ?? '--'}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Drawing No.: ${data['formData']['drawingNum'] ?? '--'}',
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
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.45,
                          child: Row(
                            children: [
                              Text('Dimensions:',
                                  style: bigBoldFontStyle.copyWith()),
                              Container(
                                  height: 20,
                                  width: width * 0.25,
                                  child: TextField()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Row(
                            children: [
                              Text('By:', style: bigBoldFontStyle.copyWith()),
                              Container(
                                  height: 20,
                                  width: width * 0.40,
                                  child: TextField()),
                            ],
                          ),
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
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Tube remaining - 3',
                      style: bigFontStyle,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'Inspector: S M Shaikh',
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
                                content: Text(
                                    'Do you want to mark this tube as scrap'),
                                actions: [
                                  RaisedButton(
                                    onPressed: () {
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
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _tubeLength,
//                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Tube Length',
//                    fillColor: (_issueOdStart) ? Colors.red : Colors.white,
//                    filled: true,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _shuntTubeLength,
//                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Shunt Tube length',
                    border: new OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  controller: _stp,
//                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'STP',
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  controller: _idDrift,
//                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'ID Drift',
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  controller: _endGage,
//                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'End Gage',
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
                      Text(
                          'These tubes have been inspected and meet drawing specifications.',
                          style: bigFontStyle.copyWith(fontSize: 18)),
                      Text(
                          'All parts will be made from drawing for part number listed above.',
                          style: bigFontStyle.copyWith(fontSize: 18)),
                      Text(
                          'All parts will be checked with drawing for part number listed above.',
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
                        onPressed: () {},
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
}
