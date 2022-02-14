import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';
import 'package:tpmapp/models/device_list.dart';
import 'package:tpmapp/services/api_call.dart';
import 'package:tpmapp/services/preferences_service.dart';

class DeviceSetupScreen extends StatefulWidget {
  final PreferencesService pref;
  DeviceSetupScreen(this.pref, {Key key}) : super(key: key);
  @override
  _DeviceSetupScreenState createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  List<DeviceList> millList = [];
  DeviceList selectedMill;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  APICall api;
  Future<void> loadData() async {
    isLoading = true;
    setState(() {});
    api = APICall();
    millList = widget.pref.deviceList;
    // millList = List<DeviceList>.from(mList);
    setState(() {
      isLoading = false;
      if (millList.length > 0) selectedMill = millList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mill Device Setup'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.modeSelection);
          },
        ),
      ),
      body: (isLoading)
          ? Container(child: Center(child: CircularProgressIndicator()))
          : (millList.length > 0)
              ? Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonFormField(
                            decoration:
                                InputDecoration(labelText: 'Select Mill'),
                            isExpanded: true,
                            value: selectedMill,
                            onChanged: (v) {
                              selectedMill = v;
                            },
                            items: millList.map<DropdownMenuItem<DeviceList>>(
                                (DeviceList value) {
                              return DropdownMenuItem<DeviceList>(
                                value: value,
                                child: Text('${value.device}'),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: RaisedButton(
                              color: primaryColor,
                              onPressed: () async {
                                var ret = await api.setDeviceMAC(
                                    widget.pref, selectedMill.device);
                                if (ret != null) {
                                  if (ret['result'] == 1 || ret['result'] == 2)
                                    Flushbar(
                                      message: ret['message'],
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                  else
                                    Flushbar(
                                      message: ret['message'],
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ).show(context);
                                } else {
                                  Flushbar(
                                    message: 'Problem in data updated',
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ).show(context);
                                }
                              },
                              child: Text(
                                'Update',
                                style:
                                    bigFontStyle.copyWith(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Center(child: Text('Problem in fetching data....'))),
    );
  }
}
