import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'navigation_one.dart';
import 'package:intl/intl.dart';

class TubeMillLogs extends StatefulWidget {
  @override
  _TubeMillLogsState createState() => _TubeMillLogsState();
}

class _TubeMillLogsState extends State<TubeMillLogs> {
  double width = 0;
  double height = 0;
  bool isStarted = false;
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MyBottomNavigationBarOne(
        AppBar(title: Text('Tube Mill Logs')),
        new DefaultTabController(
          length: 2, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    color: Color.fromRGBO(153, 206, 238, 1),
                    height: 100.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Date: 01-05-2020',
                                  style: bigBoldFontStyle.copyWith()),
                              Text('Tube OD : 40268',
                                  style: bigBoldFontStyle.copyWith()),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PO#: PO31107226',
                                  style: bigBoldFontStyle.copyWith()),
                              Text('Job#: 7750',
                                  style: bigBoldFontStyle.copyWith()),
                              Text('Line Item: 1',
                                  style: bigBoldFontStyle.copyWith()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ])),
                SliverToBoxAdapter(
                  child: TabBar(
                    tabs: [
                      Tab(
                          child: Text('Operator’s Sign On',
                              style: TextStyle(color: Colors.black))),
                      Tab(
                          child: Text('Coil Changes',
                              style: TextStyle(color: Colors.black))),
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                if (!isStarted)
                                  Container(
                                    height: 50,
                                    width: width * 0.95,
                                    child: RaisedButton(
                                      color: primaryColor,
                                      onPressed: () {
                                        setState(() {
                                          isStarted = true;
                                        });
                                      },
                                      child: const Text('Start',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                if (isStarted)
                                  Container(
                                    width: width * 0.95,
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              width: 0.74,
                                              color: Colors.white)),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 5,
                                          bottom: 40,
                                          top: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10, top: 20),
                                            child: Text(
                                                "Stared At: 04-05-2020 10:50 AM",
                                                style: bigBoldFontStyle
                                                    .copyWith()),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Initials',
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Reasons',
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Time of Day ',
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Seconds per Rev ',
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 10),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Tubes per Hour',
                                                border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 50,
                                            width: width * 0.9,
                                            child: RaisedButton(
                                              color: primaryColor,
                                              onPressed: () {
                                                setState(() {
                                                  isStarted = false;
                                                });
                                              },
                                              child: const Text('Stop',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                new GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 170,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 10,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: EdgeInsets.only(
                                          right: 10, left: 8, top: 5),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 15,
                                            left: 15,
                                            top: 15,
                                            bottom: 15),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '04-05-2020 08:00',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '04-05-2020 09:00',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Initials',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Reasons',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Time of Day',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Seconds per Rev: 500',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Tubes per Hour: 10',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: width,
                      height: height - 50,
                      child: Column(
                        children: <Widget>[
                          new DefaultTabController(
                            length: 3, // This is the number of tabs.
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(
                                        child: Text('Data tab1',
                                            style: TextStyle(
                                                color: Colors.black))),
                                    Tab(
                                        child: Text('Scrap info',
                                            style: TextStyle(
                                                color: Colors.black))),
                                    Tab(
                                        child: Text('Total info',
                                            style: TextStyle(
                                                color: Colors.black))),
                                  ],
                                ),
                                Container(
                                  height: height - 100,
                                  width: width,
                                  child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                        height: height - 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: width,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  width: width * 0.95,
                                                  child: Card(
                                                    elevation: 10,
                                                    shadowColor: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            side: BorderSide(
                                                                width: 0.74,
                                                                color: Colors
                                                                    .white)),
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        right: 5,
                                                        bottom: 5,
                                                        top: 20),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10,
                                                                  top: 20),
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Time of Day ',
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderSide:
                                                                    new BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10),
                                                          child: Column(
                                                              children: <
                                                                  Widget>[
                                                                DateTimeField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Stop Time (${format.pattern})',
                                                                    border:
                                                                        new OutlineInputBorder(
                                                                      borderSide:
                                                                          new BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  format:
                                                                      format,
                                                                  onShowPicker:
                                                                      (context,
                                                                          currentValue) {
                                                                    return showDatePicker(
                                                                        context:
                                                                            context,
                                                                        firstDate: DateTime(
                                                                            1900),
                                                                        initialDate: currentValue ??
                                                                            DateTime
                                                                                .now(),
                                                                        lastDate:
                                                                            DateTime(2100));
                                                                  },
                                                                ),
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10),
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Tubes per Coil',
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderSide:
                                                                    new BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10),
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Weight per Coil  ',
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderSide:
                                                                    new BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.0,
                                                                  right: 10),
                                                          child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Welded Splice Inspected by',
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderSide:
                                                                    new BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          height: 50,
                                                          width: width * 0.9,
                                                          child: RaisedButton(
                                                            color: primaryColor,
                                                            onPressed: () {},
                                                            child: const Text(
                                                                'Save',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                timewiseDetails(),
                                                timewiseDetails(),
                                                timewiseDetails(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: width * 0.95,
                                              child: Card(
                                                elevation: 10,
                                                shadowColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                        width: 0.74,
                                                        color: Colors.white)),
                                                margin: EdgeInsets.only(
                                                    left: 10,
                                                    right: 5,
                                                    bottom: 5,
                                                    top: 20),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10,
                                                          top: 20),
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Scrap Material per Inch ',
                                                          border:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                new BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10.0,
                                                          right: 10),
                                                      child: TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Reason ',
                                                          border:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                new BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      width: width * 0.9,
                                                      child: RaisedButton(
                                                        color: primaryColor,
                                                        onPressed: () {},
                                                        child: const Text(
                                                            'Save',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            scrapReasonCard(),
                                            scrapReasonCard(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: width * 0.95,
                                        child: Card(
                                          elevation: 10,
                                          shadowColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                  width: 0.74,
                                                  color: Colors.white)),
                                          margin: EdgeInsets.only(
                                              left: 10,
                                              right: 5,
                                              bottom: 5,
                                              top: 20),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10,
                                                    top: 20),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Total Tubes per Day',
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Total ',
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 50,
                                                width: width * 0.9,
                                                child: RaisedButton(
                                                  color: primaryColor,
                                                  onPressed: () {},
                                                  child: const Text('Save',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
//                         child: Padding(
//                            padding: EdgeInsets.only(left: 10, right: 10),
//                            child: Column(
//                              children: <Widget>[
//
//
//                                SizedBox(
//                                  height: 20,
//                                ),
//
//                              ],
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        0);
  }

  Widget timewiseDetails() {
    return new GestureDetector(
      onTap: () {},
      child: Container(
        height: 200,
        child: Card(
          color: Colors.white,
          elevation: 10,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(right: 10, left: 10, top: 5),
          child: Row(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'Time of Day',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Stop Time',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tubes per Coil',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Weight per Coil',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welded Splice Inspected by',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//scrap reason card
  Widget scrapReasonCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Card(
          color: Colors.white,
          elevation: 10,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(right: 10, left: 8, top: 5),
          child: Row(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 15, top: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'Scrap Material per Inch',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Reason ',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
