import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'navigation_one.dart';
import 'package:intl/intl.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:custom_switch/custom_switch.dart';

class WeldingSCSheet extends StatefulWidget {
  @override
  _WeldingSCSheetState createState() => _WeldingSCSheetState();
}

class _WeldingSCSheetState extends State<WeldingSCSheet> {
  final format = DateFormat("yyyy-MM-dd");
  double height = 0;
  double width = 0;
  bool status = false;
  bool isStarted = false;
  int selectedTube = -1;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MyBottomNavigationBarOne(
        AppBar(title: Text('Welding-Station Check Sheet')),
        new DefaultTabController(
          length: 3, // This is the number of tabs.
          child: Column(
            children: [
              Container(
                  color: Color.fromRGBO(153, 206, 238, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.32,
                          child: Text('Job#: 7750',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.32,
                          child: Text('PO#: PO31107226',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                        SizedBox(
                          width: width * 0.32,
                          child: Text('Line Item: 1',
                              style: bigBoldFontStyle.copyWith()),
                        ),
                      ],
                    ),
                  )),
              Container(
                child: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Basic Details',
                            style: TextStyle(color: Colors.black))),
                    Tab(
                        child: Text('Tube Details',
                            style: TextStyle(color: Colors.black))),
                    Tab(
                        child: Text('Scarp Details',
                            style: TextStyle(color: Colors.black))),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: height - 230,
                  color: Colors.white,
                  child: TabBarView(
                    children: [
                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (!isStarted)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                width: width * 0.95,
                                child: RaisedButton(
                                  color: primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      isStarted = true;
                                    });
                                  },
                                  child: const Text('Show more',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          if (isStarted)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.95,
                                            child: Text(
                                                'Cutoff: 290  +0.125  +0.125',
                                                style: bigBoldFontStyle),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.95,
                                            child: Text(
                                                'OD: 4.626   +0.03  +0.03',
                                                style: bigBoldFontStyle),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: width * 0.5,
                                            child: Text(
                                              'Date Started: 18-Jun-2020 ',
                                              style: bigBoldFontStyle,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.45,
                                            child: Text(
                                              'Total Order: 10',
                                              style: bigBoldFontStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Text('Welding',
                                              style: bigBoldFontStyle)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.35,
                                            child: Text(
                                                'Spec Mill: TPM-WPS-316S',
                                                style: bigBoldFontStyle),
                                          ),
                                          SizedBox(
                                            width: width * 0.3,
                                            child: Text('Amps: 218-270',
                                                style: bigBoldFontStyle),
                                          ),
                                          SizedBox(
                                            width: width * 0.3,
                                            child: Text('Volts: 13.9-14.3',
                                                style: bigBoldFontStyle),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: width * 0.30,
                                            child: Text(
                                                'Min. Travel Speed : 40-57',
                                                style: bigBoldFontStyle),
                                          ),
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Text('Torch height: .575',
                                                style: bigBoldFontStyle),
                                          ),
                                          SizedBox(
                                            width: width * 0.20,
                                            child: Text('Arc Length: 0.075',
                                                style: bigBoldFontStyle),
                                          ),
                                          SizedBox(
                                            width: width * 0.20,
                                            child: Text('Torch angle: 12',
                                                style: bigBoldFontStyle),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
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
                                          child: const Text('Show less',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 10),
                          Container(
                            padding:
                                EdgeInsets.only(left: 15.0, right: 15, top: 0),
//                            height: 400,
                            child: Card(
                              color: Colors.white,
                              elevation: 10,
                              shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
//                      margin: EdgeInsets.only(right: 10, left: 8, top: 5),
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 10, left: 10, top: 15, bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10, top: 20),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Tube Remaining ',
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10, top: 15),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Operator ',
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Column(children: <Widget>[
                                        DateTimeField(
                                          decoration: InputDecoration(
                                            hintText: 'Dates Tubes Made',
                                            border: new OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          format: format,
                                          onShowPicker:
                                              (context, currentValue) {
                                            return showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1900),
                                                initialDate: currentValue ??
                                                    DateTime.now(),
                                                lastDate: DateTime(2100));
                                          },
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10, top: 15),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Mill Operator ',
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
                                        child: const Text('Save',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              tubewiseDetailsCard('Tube :7750 -001', 0),
                              SizedBox(height: 30),
                              tubewiseDetailsCard('Tube :7750 -002', 1),
                              SizedBox(height: 30),
                              tubewiseDetailsCard('Tube :7750 -003', 2),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
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
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            width: 0.74, color: Colors.white)),
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
                                              "Stared At: 04-02-2020 05:30 PM",
                                              style:
                                                  bigBoldFontStyle.copyWith()),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Total Scrap',
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
                                            child: const Text('Stop Times',
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
                              SizedBox(
                                height: 15,
                              ),
                              new GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 80,
                                  width: width * 0.95,
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
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: width * 0.65,
                                                  child: Text(
                                                    'Stared At: 04-02-2020 05:30 PM',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Stared At: 04-02-2020 05:45 PM',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '500',
                                                  style: bigBoldFontStyle
                                                      .copyWith(),
                                                  textAlign: TextAlign.end,
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        2);
  }

  Widget tubewiseDetailsCard(String title, int index) {
    return (selectedTube != index)
        ? Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTube = index;
                  });
                },
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$title', style: bigBoldFontStyle),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('OD Check ', style: bigBoldFontStyle),
                          Text('OD Check ', style: bigBoldFontStyle),
                        ],
                      ),
                      Text('Remarks', style: bigBoldFontStyle),
                      Text('Tungsten Change : Yes', style: bigBoldFontStyle),
                    ],
                  ),
                )),
              ),
            ),
          )
        : Container(
            height: 430,
            width: width * 0.95,
            child: Card(
              elevation: 10,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(width: 0.74, color: Colors.white)),
              margin: EdgeInsets.only(
                left: 10,
                right: 5,
                bottom: 5,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                            '$title',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          height: 28,
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                selectedTube = -1;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.black,
                            ),
//                      backgroundColor:
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'OD Check ',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'OD Check',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Remarks',
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15),
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: Text('Tungsten Change',
                            style: setupTextstyleColor.copyWith()),
                      ),
                      Switch(
                        activeColor: Colors.pinkAccent,
                        value: status,
                        onChanged: (value) {
                          print("VALUE : $value");
                          setState(() {
                            status = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    width: width * 0.9,
                    child: RaisedButton(
                      color: primaryColor,
                      onPressed: () {
                        setState(() {
                          selectedTube = -1;
                        });
                      },
                      child: const Text('Save',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
