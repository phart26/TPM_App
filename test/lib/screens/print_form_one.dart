import 'package:flutter/material.dart';

import 'navigation_one.dart';

class PFOne extends StatefulWidget {
  @override
  _PFOneState createState() => _PFOneState();
}

class _PFOneState extends State<PFOne> {
  @override
  Widget build(BuildContext context) {
    return MyBottomNavigationBarOne(
      AppBar(
        title: Text('Test page one'),
      ),
      Container(
        child: Text('test'),
      ),
      0,
    );
  }
}
