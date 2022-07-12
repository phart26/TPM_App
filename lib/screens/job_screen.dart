import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tpmapp/services/api_call.dart';
import '../constants/routes_name.dart';
import 'package:tpmapp/screens/mill_operator/tube_mill_setup_form.dart';
import '../constants/my_style.dart';
import '../services/preferences_service.dart';
import 'package:tpmapp/models/my_utils.dart';

class JobScreen extends StatefulWidget {
  final PreferencesService pref;

  JobScreen(this.pref, {Key key}) : super(key: key);
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  double height = 0;
  double width = 0;
  int selected = -1;
  bool isDataLoading = false;
  String isLoadingJob = "";
  Map<String, dynamic> data;
  APICall apiCall;
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
    apiCall = APICall();
    await apiCall.getData(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
      print("-d>>>>>>>>>>>>.load dataa ${data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if ((data == null) || data['jobsInsp'].isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Job List'),
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(153, 206, 238, 1)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.loginScreen);
                              },
                              child: Text('Log Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: width * .30,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(153, 206, 238, 1)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.modeSelection);
                              },
                              child: Text('Home Page',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isDataLoading)
                              ? Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      SizedBox(height: 20),
                                      Text(
                                          'Please wait we are fetching data...')
                                    ],
                                  ))
                              : Expanded(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('No Active Jobs',
                                        style: bigFontStyle.copyWith(
                                            color: Colors.black))
                                  ],
                                )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Job List'),
        ),
        body: ListView.builder(
            itemCount: data['jobsInsp'].length,
            itemBuilder: (context, index) {
              return getJobCard(
                  '${data['jobsInsp'][index][0]}',
                  index,
                  '${data['jobsInsp'][index][1]}',
                  '${data['jobsInsp'][index][2]}');
            }),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: secondaryColor,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.modeSelection);
          },
          label: Text('Home Page', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget getJobCard(String job, int index, String od, String length) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
      child: InkWell(
        onTap: () async {
          setState(() {
            isLoadingJob = job;
          });
          widget.pref.jobId = job;
          apiCall = APICall();
          await apiCall.getData(widget.pref);
          setState(() {
            isLoadingJob = "";
          });
          Navigator.of(context)
              .pushReplacementNamed(Routes.formSelectionScreen);
        },
        child: Card(
          key: ObjectKey(job),
          color: (index == selected) ? primaryColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job #$job' +
                      '        ' +
                      'OD: $od' +
                      '        ' +
                      'Length: $length',
                  style: bigFontStyle.copyWith(
                    color: (index != selected) ? primaryColor : Colors.white,
                    fontSize: 30,
                  ),
                ),
                if (isLoadingJob == job)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
