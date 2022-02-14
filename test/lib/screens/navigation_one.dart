import 'package:flutter/material.dart';
import 'tube_mill_logs.dart';
import 'tube_mill_seteup.dart';
import 'weilding_station_check_sheet.dart';
import 'worksheet.dart';

class MyBottomNavigationBarOne extends StatefulWidget {
  AppBar appBar;
  Widget body;
  int pageIndex;
  MyBottomNavigationBarOne(this.appBar, this.body, this.pageIndex, {Key key})
      : super(key: key);
  @override
  __MyBottomNavigationBarOneState createState() =>
      __MyBottomNavigationBarOneState();
}

class __MyBottomNavigationBarOneState extends State<MyBottomNavigationBarOne> {
  int _currentIndex = 0;
  void ontapprdBar(int index) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => _children[index]));
  }

  final List<Widget> _children = [
    TubeMillLogs(),
    TubeMillSetup(),
    WeldingSCSheet(),
    WorkSheet(),
//    Subscriber(),
//    JobSeeker(),
//    Business(),
//    Consultancy(),
  ];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        onTap: ontapprdBar,
        currentIndex: widget.pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.business,
              color: Colors.white,
            ),
            title: Text(
              'Tube Mill Log',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.markunread_mailbox,
              color: Colors.white,
            ),
            title: Text(
              'Tube-Mill Setup',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            title: Text(
              'Welding-Station Check Sheet',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            title: Text(
              'Worksheet',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
