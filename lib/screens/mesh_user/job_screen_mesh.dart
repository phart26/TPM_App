import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tpmapp/services/api_call.dart';
import '../../constants/routes_name.dart';
import '../../constants/my_style.dart';
import '../../services/preferences_service.dart';
import 'package:tpmapp/models/my_utils.dart';

class MeshJobScreen extends StatefulWidget {
  final PreferencesService pref;

  MeshJobScreen(this.pref, {Key key}) : super(key: key);
  @override
  _MeshJobScreenState createState() => _MeshJobScreenState();
}

class _MeshJobScreenState extends State<MeshJobScreen> {
  int selected = -1;
  bool isDataLoading = false;
  Map<String, dynamic> data;
  APICall apiCall;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    setState(() {
      isDataLoading = true;
    });
    apiCall = APICall();
    await apiCall.getMeshJobData(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.meshJobData);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data['meshJobs'].length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Job List'),
        ),
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Text('No Active Jobs',
                    style: bigFontStyle.copyWith(color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    color: secondaryColor,
                    onPressed: () async {
                      //Update the api
                      await apiCall.getMeshJobData(widget.pref);

                      setState(() {
                        data = json.decode(widget.pref.meshJobData);
                      });
                    },
                    child: Text('Refresh',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Job List'),
        ),
        body: ListView.builder(
            itemCount: data['meshJobs'].length,
            itemBuilder: (context, index) {
              return getJobCard(
                '${data['meshJobs'][index]['po']}', // po
                '${data['meshJobs'][index]['mat_type']}', // material
                '${data['meshJobs'][index]['quantity']}', //qty
                index,
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: secondaryColor,
          onPressed: () async {
            //Update the api
            await apiCall.getMeshJobData(widget.pref);

            setState(() {
              data = json.decode(widget.pref.meshJobData);
            });
          },
          label: Text('Refresh', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget getJobCard(String po, String material, String qty, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
      child: InkWell(
        onTap: () async {
          widget.pref.meshJobPo = po;
          await apiCall.getMeshData(widget.pref);
          Navigator.of(context).pushReplacementNamed(Routes.meshComboScreen);
        },
        child: Card(
          color: (index == selected) ? primaryColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PO #$po' +
                      '        ' +
                      'Mesh: $material' +
                      '        ' +
                      'Qty: $qty',
                  style: bigFontStyle.copyWith(
                    color: (index != selected) ? primaryColor : Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
