import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class TestScreen extends StatefulWidget {
  final PreferencesService pref;
  TestScreen(this.pref, {Key key}) : super(key: key);
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  TextEditingController setSrcap = TextEditingController();
  FocusNode focusNodesetSrcap;
  double height = 0;
  double width = 0;
  bool bendTestVal = false;
  bool driftTestVal = false;

  @override
  void initState() {
    focusNodesetSrcap = new FocusNode();
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
          child: Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: width * 0.95, child: _getBendTestCard()),
                SizedBox(width: width * 0.95, child: _getDriftTestCard()),
                SizedBox(width: width * 0.95, child: _getScrapCard()),
                if (bendTestVal && driftTestVal && setSrcap.text.isNotEmpty)
                  SizedBox(
                    width: width * 0.9,
                    child: RaisedButton(
                        onPressed: () async {
                          await APICall().postTestResults(widget.pref);
                          await APICall().postScarp(widget.pref, "Setup Scrap",
                              "", setSrcap.text ?? "", "S");
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.weldingForm);
                        },
                        color: primaryColor,
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
              Container(
                padding:
                    EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: setSrcap,
                  focusNode: focusNodesetSrcap,
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
            ],
          ),
        ),
      ],
    ));
  }
}
