import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'navigation_one.dart';
import 'package:intl/intl.dart';

class TubeMillSetup extends StatefulWidget {
  @override
  _TubeMillSetupState createState() => _TubeMillSetupState();
}

class _TubeMillSetupState extends State<TubeMillSetup> {
  bool checkBoxValue = false;
  double height = 0;
  double width = 0;
  bool isStarted = false;
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MyBottomNavigationBarOne(
        AppBar(title: Text('Tube Mill Setup')),
        new DefaultTabController(
            length: 3, // This is the number of tabs.
            child: Column(
              children: [
                Container(
                    color: Color.fromRGBO(153, 206, 238, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
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
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.32,
                                child: Text('Date: 01-Jul-2020',
                                    style: bigBoldFontStyle.copyWith()),
                              ),
                              SizedBox(
                                width: width * 0.32,
                                child: Text('Type: 316L',
                                    style: bigBoldFontStyle.copyWith()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Container(
                  child: TabBar(
                    tabs: [
                      Tab(
                          child: Text('Basic Details',
                              style: bigBoldFontStyle.copyWith(
                                  color: Colors.black))),
                      Tab(
                          child: Text('MFG Notes',
                              style: bigBoldFontStyle.copyWith(
                                  color: Colors.black))),
                      Tab(
                          child: Text('Mill Inspection ',
                              style: bigBoldFontStyle.copyWith(
                                  color: Colors.black))),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: height - 260,
                    color: Colors.white,
                    child: TabBarView(
                      children: [
                        Container(
                          child: Column(
                            children: [
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
                                                child: Text(
                                                    'Torch height: .575',
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Column(children: <Widget>[
                                            DateTimeField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Setup start time: (${format.pattern})',
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
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: width,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text('Bend Test ',
                                            textAlign: TextAlign.left,
                                            style: bigBoldFontStyle),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: checkBoxValue,
                                          onChanged: (bool value) {
                                            print(value);
                                            setState(() {
                                              checkBoxValue = value;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Pass (No visual cracks in weld)',
                                          style: bigBoldFontStyle,
                                        ),
                                        Checkbox(
                                          value: checkBoxValue,
                                          onChanged: (bool value) {
                                            print(value);
                                            setState(() {
                                              checkBoxValue = value;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Fail',
                                          style: bigBoldFontStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Operator for Setup ',
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Operator Notes',
                                          border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
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
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'BURR OUT. USE DRIFT SIZE 4.075". FILTER 01 LAYER 316L, 14X88, 5.80" WIDE. FILTER 02 LAYER 316L, 14X88, 5.80" WIDE. DRAINAGE LAYER 316L, 20X20, 5.80" WIDE. *DRAINAGE LAYER SITS ON OTR SHRD, FIRST FILTER LYR SITS ON DRAINAGE LAYER, SECOND FILTER LYR SITS ON FIRST FILTER LYR BUT OFFSET 1/2 THE WIDTH OF THE FIRST FILTER LYR.',
                              maxLines: 20,
                              style: bigBoldFontStyle,
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text('1. Clean mill table and area ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('2. Receive setup paperwork ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('3. Check steel for straightness ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('4. Inspect die and clamps ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('5. Check level of front plate  ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('6. Check that table is level ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text(
                                    '7. Check that all chains, adjustment nuts, and bolts are tight',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text(
                                    '8. Use the proper shoot and shim as per paperwork (last setup) ',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('9. Fill out pre-startup check sheet',
                                    style: bigBoldFontStyle),
                                SizedBox(height: 5),
                                Text('10. If needed, get a second opinion',
                                    style: bigBoldFontStyle),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        1);
  }
}
