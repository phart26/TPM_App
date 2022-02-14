import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/form_details.dart';
import 'package:tpmapp/models/inspection_job_details.dart';
import 'package:tpmapp/models/my_utils.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class GeoFormSelectionScreen extends StatefulWidget {
  final PreferencesService pref;

  GeoFormSelectionScreen(this.pref, {Key key}) : super(key: key);
  @override
  _GeoFormSelectionScreenState createState() => _GeoFormSelectionScreenState();
}

class _GeoFormSelectionScreenState extends State<GeoFormSelectionScreen> {
  List<FormDetails> formsList = [
    new FormDetails('Inspection Station - check sheet', "iSCs",
        Routes.inspectionStationCheckSheet),
    new FormDetails(
        'Final Inspection Geo Form', "fIGf", Routes.finalInspectionGeoForm),
    new FormDetails(
        'Cutoff Station - Check sheet', "cSCs", Routes.cutoffStationCheckSheet),
    new FormDetails('Ring Weld Sheet', "rWS", Routes.ringWeldSheet)
  ];

  bool isDataLoading = false;
  Map<String, dynamic> data;
  int qty = 0;
  List<InspectionJobDetails> details;
  @override
  void initState() {
    verifyJobTable();
    super.initState();
  }

  Future<void> verifyJobTable() async {
    await loadData();
    List<Tube> tubes = [];
    for (var i = 1; i <= qty; i++) {
      var tubeNo = MyUtils.generateTubeNumber(qty, widget.pref.jobId, i);
      tubes.add(Tube(tubeNo: tubeNo, isCompleted: false));
    }
    if (widget.pref.jobwisetubeDetails == "") {
      details = [];
      details.add(InspectionJobDetails(
        jobId: data['formData']['job'],
        iSCs: CSCs(qty: qty, tubes: tubes),
        fIGf: CSCs(qty: qty, tubes: tubes),
        cSCs: CSCs(qty: qty, tubes: tubes),
      ));
    } else {
      details = inspectionJobDetailsFromJson(widget.pref.jobwisetubeDetails);
      int i = details
          .indexWhere((element) => element.jobId == data['formData']['job']);
      if (i == -1) {
        details.add(InspectionJobDetails(
          jobId: data['formData']['job'],
          iSCs: CSCs(qty: qty, tubes: tubes),
          fIGf: CSCs(qty: qty, tubes: tubes),
          cSCs: CSCs(qty: qty, tubes: tubes),
        ));
      }
    }
    widget.pref.jobwisetubeDetails = json.encode(details);

    print('widget.pref.jobwisetubeDetails ${widget.pref.jobwisetubeDetails}');
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
      qty = int.parse(data['formData']['quantity'] ?? "10");
    });
    print(data);
    print('form datas ${data['formData']['quantity']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form selection')),
      body: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: ListView.builder(
            itemCount: formsList.length,
            itemBuilder: (context, index) {
              return _formCard(formsList[index]);
            },
          )),
    );
  }

  _formCard(FormDetails formDetails) {
    return InkWell(
      onTap: () {
        // setting tube list so api knows what tubes to pull
        widget.pref.tubeListSheet = formDetails.shortNm;
        Navigator.of(context).pushReplacementNamed(Routes.tubeSelectionScreen);
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
                      formDetails.formTitle,
                      style: bigBoldFontStyle.copyWith(
                        fontSize: 26,
                      ),
                    )),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          )),
    );
  }
}
