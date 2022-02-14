import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class TubeSelectionScreen extends StatefulWidget {
  final PreferencesService pref;
  final String route;
  final String shortNm;

  TubeSelectionScreen(this.pref, this.shortNm, this.route, {Key key})
      : super(key: key);

  @override
  _TubeSelectionScreenState createState() => _TubeSelectionScreenState();
}

class _TubeSelectionScreenState extends State<TubeSelectionScreen> {
  bool isDataLoading = false;
  Map<String, dynamic> data;
  int qty = 0;
  List<InspectionJobDetails> details;
  @override
  void initState() {
//    print('Job listed ${widget.pref.token}');
//    if (widget.pref.token == null || widget.pref.token == "")
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    setState(() {
      isDataLoading = true;
    });
//    APICall apiCall = APICall();
//    await apiCall.getData(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
      qty = int.parse(data['formData']['quantity'] ?? "10");
    });
    print(data);
    print('form datas ${data['formData']['quantity']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tube Selection')),
      body: (isDataLoading)
          ? Container(child: Center(child: CircularProgressIndicator()))
          : Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: myTubeList(),
              )
//              ListView.builder(
//                itemCount: qty,
//                itemBuilder: (context, index) {
//                  Random rand = Random();
//                  String tubeNumber = MyUtils.generateTubeNumber(
//                      qty, widget.pref.jobId, index + 1);
////                      rand.nextInt(index + 300).toString() +
////                      '-' +
////                      rand.nextInt(index + 1 * 100).toString() +
////                      '-' +
////                      rand.nextInt(index + 1 * 200).toString();
//                  return _tubeCard(tubeNumber, index);
//                },
//              )
              ),
    );
  }

  List<Widget> myTubeList() {
    List<Widget> myWidgets = [];
    List<Tube> tubes = [];
    details = inspectionJobDetailsFromJson(widget.pref.jobwisetubeDetails);
    int i = details
        .indexWhere((element) => element.jobId == data['formData']['job']);

    switch (widget.shortNm) {
      case "dPI":
        tubes = details[i].dPI.tubes;
        break;
      case "iSCs":
        tubes = details[i].iSCs.tubes;
        break;
      case "fIGf":
        tubes = details[i].fIGf.tubes;
        break;
      case "cSCs":
        tubes = details[i].cSCs.tubes;
        print(tubes);
        break;
      case "gFRI":
        tubes = details[i].gFRI.tubes;
        break;
      case "rSCs":
        tubes = details[i].rSCs.tubes;
        break;
    }
    int count = 0;
    tubes.forEach((tube) {
      if (!tube.isCompleted) {
        myWidgets.add(_tubeCard(tube.tubeNo, count));
      }
      count++;
    });

    return myWidgets;
  }

  _tubeCard(String tube, int index) {
    return InkWell(
        onTap: () {
          print('${widget.route}');
          widget.pref.currentTube = index;
          widget.pref.currentTubeNo = tube;
          Navigator.of(context).pushReplacementNamed(widget.route);
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
