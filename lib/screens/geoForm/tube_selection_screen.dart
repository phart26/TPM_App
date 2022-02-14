import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/constants/routes_name.dart';

class TubeSelectionScreen extends StatefulWidget {
  final PreferencesService pref;

  TubeSelectionScreen(this.pref, {Key key}) : super(key: key);

  @override
  _TubeSelectionScreenState createState() => _TubeSelectionScreenState();
}

class _TubeSelectionScreenState extends State<TubeSelectionScreen> {
  bool isDataLoading = false;
  Map<String, dynamic> data;
  int qty = 0;
  Map<String, dynamic> tubes;
  List<InspectionJobDetails> details;
  APICall api = APICall();
  double width = 0;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    tubes = await api.getGeoTubes(widget.pref, widget.pref.tubeListSheet);
    setState(() {
      isDataLoading = true;
    });
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    int count = 1;
    return Scaffold(
      appBar: AppBar(title: Text('Tube Selection')),
      body: (isDataLoading)
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: width * .45,
                      child: RaisedButton(
                        color: secondaryColor,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.modeSelection);
                        },
                        child: Text('Home Page',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: width * .45,
                      child: RaisedButton(
                        color: secondaryColor,
                        onPressed: () async {
                          //Update the api
                          tubes = await api.getGeoTubes(
                              widget.pref, widget.pref.tubeListSheet);
                          setState(() {});
                        },
                        child: Text('Refresh',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  if (tubes['tubes'].length > 0)
                    for (var tube in tubes['tubes'])
                      _tubeCard(tube, count++, context),
                  if (tubes['tubes'].length == 0)
                    SizedBox(
                      width: width * 0.97,
                      child: Text('No Tubes Available',
                          style: bigFontStyle.copyWith(color: Colors.black)),
                    ),
                ],
              )),
    );
  }

  _tubeCard(String tube, int index, BuildContext context) {
    return InkWell(
        onTap: () {
          widget.pref.currentTube = index;
          widget.pref.currentTubeNo = tube;
          if (widget.pref.tubeListSheet == "cSCs")
            Navigator.of(context)
                .pushReplacementNamed(Routes.geoCutoffStationCheckSheet);
          if (widget.pref.tubeListSheet == "iSCs")
            Navigator.of(context)
                .pushReplacementNamed(Routes.geoInspectionStationCheckSheet);
          if (widget.pref.tubeListSheet == "fIGf")
            Navigator.of(context)
                .pushReplacementNamed(Routes.finalInspectionGeoForm);
          if (widget.pref.tubeListSheet == "rWS")
            Navigator.of(context).pushReplacementNamed(Routes.ringWeldSheet);
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        tube,
                        style: bigBoldFontStyle,
                      )),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            )));
  }
}
