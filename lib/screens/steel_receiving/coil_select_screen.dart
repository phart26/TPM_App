import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tpmapp/services/api_call.dart';
import '../../constants/routes_name.dart';
import '../../constants/my_style.dart';
import '../../services/preferences_service.dart';

class CoilSelectScreen extends StatefulWidget {
  final PreferencesService pref;

  CoilSelectScreen(this.pref, {Key key}) : super(key: key);
  @override
  CoilSelectScreenState createState() => CoilSelectScreenState();
}

class CoilSelectScreenState extends State<CoilSelectScreen> {
  double height = 0;
  double width = 0;
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
    await apiCall.getCoilsStamp(widget.pref);
    setState(() {
      isDataLoading = false;
      data = json.decode(widget.pref.jobData);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if ((data==null) || data['coils'].isEmpty) {
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
                            child: RaisedButton(
                              color: secondaryColor,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.loginScreen);
                              },
                              child: Text('Log Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: width * .30,
                            child: RaisedButton(
                              color: secondaryColor,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.modeSelection);
                              },
                              child: Text('Home Page',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Text('No Coils to Check In',
                                style:
                                    bigFontStyle.copyWith(color: Colors.black)),
                          ),
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
          title: Text('Coil List'),
        ),
        body: ListView.builder(
            itemCount: data['coils'].length,
            itemBuilder: (context, index) {
              return getJobCard('${data['coils'][index]}', index);
            }),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: secondaryColor,
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(Routes.jobScreenSteelReceiving);
          },
          label: Text('Job Screen', style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget getJobCard(String coil, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
      child: InkWell(
        onTap: () async {
          widget.pref.coilNum = coil;
          BuildContext dialogContext;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              dialogContext = context;
              return AlertDialog(
                title: Text('Confirm'),
                content: Container(
                  height: 200,
                  width: 250,
                  child: Column(
                    children: [
                      Text('Check in coil ' + widget.pref.coilNum + ' ?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                actions: [
                  RaisedButton(
                    onPressed: () async {
                      Map<String, dynamic> map = {
                        "checkInCoilData": {
                          "receiveCoil_op": "${widget.pref.userDetails.userId}",
                          "job": '${widget.pref.jobId}',
                          "coil_no": widget.pref.coilNum
                        }
                      };
                      await apiCall.postCoilCheckIn(map);
                      //Update the api
                      await apiCall.getCoilsStamp(widget.pref);

                      setState(() {
                        data = json.decode(widget.pref.jobData);
                      });
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
        child: Card(
          color: (index == selected) ? primaryColor : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coil #$coil',
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
