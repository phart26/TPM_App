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

// import 'package:wifi/wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:multicast_dns/multicast_dns.dart';

class MeshComboScreen extends StatefulWidget {
  final PreferencesService pref;

  MeshComboScreen(this.pref, {Key key}) : super(key: key);
  @override
  _MeshComboScreenState createState() => _MeshComboScreenState();
}

class _MeshComboScreenState extends State<MeshComboScreen> {
  bool coilAvail = false;
  int tubesFinished = 0;
  double height = 0;
  double width = 0;
  Map<String, dynamic> data;
  Map<String, dynamic> currentJob;
  Map<String, dynamic> meshjobData;
  FocusNode focusNodeLength;
  TextEditingController _scrapLength = TextEditingController();
  APICall api;

  @override
  void initState() {
    api = APICall();
    //call this after each saved tube
    //- for api call grab all tubes that have been welded and not cutoff into an array and just return the tube in spot 0
    //make that tube id the next tube number
    //evrything else the same
    setState(() {
      meshjobData = json.decode(widget.pref.meshJobData);
      data = json.decode(widget.pref.meshData);

      // find po job in meshjobData
      for (var i = 0; i < meshjobData['meshJobs'].length; i++) {
        if (meshjobData['meshJobs'][i]['po'] == widget.pref.meshJobPo) {
          currentJob = meshjobData['meshJobs'][i];
        }
      }
    });

    focusNodeLength = new FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // check if mesh combos to do
    if ('${data['meshRem']}' != "0") coilAvail = true;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesh Coil Combos'),
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
                                  .pushReplacementNamed(Routes.jobScreenMesh);
                            },
                            child: Text('PO List',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _meshInfo(),
              jobInfoCard(),
              if (coilAvail) meshSaveCard(data['mesh']['mesh_po']),
              if (!coilAvail)
                SizedBox(
                  width: width * 0.97,
                  child: Text('No mesh Available',
                      style: bigFontStyle.copyWith(color: Colors.black)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _meshInfo() {
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
                    'Mesh info',
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
                          child: Text('PO#: ${widget.pref.meshJobPo}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                              'Quantity: ${currentJob['quantity'] ?? '--'}',
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
                          width: width * 0.45,
                          child: Text('Mesh: ${data['mesh']['mat_type']}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.45,
                          child: Text('Heat#: ${currentJob['heat']}',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                  ],
                ))
          ]),
        ));
  }

  Widget jobInfoCard() {
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
                    'Job info',
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
                      'Coils Remaining: ${data["meshRem"]}   ',
                      style: bigFontStyle,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      'User: ${widget.pref.userDetails.userName}',
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

  Widget meshSaveCard(String title) {
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
                      width: width,
                      child: Text(
                        'Mesh Coil Combo Entry - ${data['mesh']['coil_no']}',
                        style: bigBoldFontStyle.copyWith(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: width,
                      child: Text(
                        'Mesh To Combine',
                        style: bigBoldFontStyle.copyWith(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // loop to generate each container for each mesh coil to combine
              for (var i = 0; i < data['mesh']['line_item'].length; i++)
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Length: ${data['mesh']['line_item'][i]['length']}',
                          style: bigBoldFontStyle.copyWith(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Text(
                          'Crate: ${data['mesh']['line_item'][i]['crate']}',
                          style: bigBoldFontStyle.copyWith(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _scrapLength,
                  focusNode: focusNodeLength,
                  decoration: InputDecoration(
                    hintText: 'Scrap Length',
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
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
                          Map<String, dynamic> map = {
                            "meshData": {
                              "coil_no": "${data['mesh']['coil_no']}",
                              "length": _scrapLength.text,
                              "user": "${widget.pref.userDetails.userId}"
                            }
                          };
                          // post entered data
                          await api.postMeshData(map);

                          //check if job is finished
                          if ('${data['meshRem']}' == "1") {
                            Map<String, dynamic> endMap = {
                              "endData": {
                                "endPo": '${widget.pref.meshJobPo}',
                              }
                            };
                            await api.postEndMesh(endMap);
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.jobScreenMesh);
                          }

                          // update the api
                          await api.getMeshData(widget.pref);
                          setState(() {
                            data = json.decode(widget.pref.meshData);
                          });

                          clearForm();

                          Flushbar(
                            title: "Coil Saved",
                            message: "Mesh saved successfully",
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          )..show(context);
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
    coilAvail = false;
    _scrapLength.clear();
  }
}
