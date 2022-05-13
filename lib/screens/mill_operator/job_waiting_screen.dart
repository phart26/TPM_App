import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';
import 'package:tpmapp/store/job_list_store.dart';
import 'dart:convert';

class JobWaitingScreen extends StatefulWidget {
  final PreferencesService pref;
  final JobListStore store;

  JobWaitingScreen(this.pref, this.store, {Key key}) : super(key: key);
  @override
  _JobWaitingScreenState createState() => _JobWaitingScreenState();
}

class _JobWaitingScreenState extends State<JobWaitingScreen> {
  APICall api = APICall();
  Map<String, dynamic> data;
  bool isLoading = false;
  @override
  void initState() {
    fetchJobs();
    super.initState();
  }

  fetchJobs() async {
    Map<String, dynamic> res = await api.getJobDetails(widget.pref);
    if(res != null)
      widget.store.addJob(res['job']);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job information')),
      body: Observer(
        builder: (_) => Container(
            child: (widget.store.jobs == "")
                ? Container(
                    child: Center(
                    child: Column(
                      children: [
                        Text('No job Assigned!',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 50,
                        ),
                        RaisedButton(
                          onPressed: () {
                            fetchJobs();
                          },
                          color: secondaryColor,
                          child: Text('Refresh',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ))
                : isLoading ?
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
                : ListView(
                    children: [getJobCard(widget.store.jobs)],
                  )),
      ),
    );
  }

  Widget getJobCard(String job) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
      child: InkWell(
        onTap: () async {
          setState(() { isLoading = true;});
          widget.pref.jobId = job;
          api = APICall();
          await api.getData(widget.pref);
          setState(() {
            data = json.decode(widget.pref.jobData);
            isLoading = false;
          });
          //Fix this
          if (data['formData']['nextTubeMill'] == "" &&
              data['formData']['nextTube'] == "" &&
              data['jobFinished'] == "0") {
            Navigator.of(context).pushReplacementNamed(Routes.tubeMillSetupForm);
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.weldingForm);
          }
        },
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //'Job #' + job.substring(0, job.indexOf('\n')),
                  'Job #' + job,
                  style: bigFontStyle.copyWith(
                    color: primaryColor,
                    fontSize: 26,
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
