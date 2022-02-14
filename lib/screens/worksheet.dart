import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'navigation_one.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class WorkSheet extends StatefulWidget {
  @override
  _WorkSheetState createState() => _WorkSheetState();
}

class _WorkSheetState extends State<WorkSheet> {
  final String description =
      "Flutter is Google’s mobile UI framework for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";

  double width = 0;
  double height = 0;
  bool isStarted = false;
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return MyBottomNavigationBarOne(
        AppBar(
            title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Worksheet'),
            Text('(Boxing Instructions and markings for Ring Installers)',
                style: bigFontStyle.copyWith()),
          ],
        )),
        SingleChildScrollView(
            child: Container(
          color: Colors.white,
          width: width,
          height: height - 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              headerInfo(),
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
              if (isStarted) moreInfoWidget(),
              Column(
                children: <Widget>[
                  Container(
//                    height: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
//                        header: Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text('Details'),
//                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 8),
                            SizedBox(
                              width: width * 0.90,
                              child: DateTimeField(
                                decoration: InputDecoration(
                                  hintText: 'Date Completed',
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                format: format,
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: width * 0.90,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'GWT',
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              width: width * 0.90,
                              child: GridTile(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Qty in each box/Pallet ',
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              width: width * 0.90,
                              child: GridTile(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Qty in each box/Pallet ',
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              width: width * 0.90,
                              child: GridTile(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Qty in each box/Pallet ',
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: width * 0.90,
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
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
        3);
  }

  Widget getQtyWidget() {
    return Container(
      height: 20,
    );
  }

  Widget moreInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: width * 0.23,
                      child:
                          Text('Part number:', style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('WSFM004-001WG',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline))),
                  SizedBox(
                      width: width * 0.23,
                      child:
                          Text('PO number:', style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('PO31107226',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)))
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Heat number (tube):',
                          style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline))),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Heat number (rings):',
                          style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)))
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Total Qty on Order:',
                          style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('10',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline))),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Container Type:',
                          style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('pallet',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)))
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.46,
                  ),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Shipping Method:',
                          style: bigFontStyle.copyWith())),
                  SizedBox(
                      width: width * 0.23,
                      child: Text('Truck',
                          style: bigFontStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)))
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.23,
                    child: Text('Inspector:', style: bigFontStyle.copyWith()),
                  ),
                  SizedBox(
                    width: width * 0.69,
                    child: Text('XYZ XYZ XYZ',
                        style: bigFontStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
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
    );
  }

  Widget headerInfo() {
    return Container(
      color: Color.fromRGBO(153, 206, 238, 1),
      height: 130.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: width * 0.23,
                  child: Text('Customer:', style: bigFontStyle.copyWith()),
                ),
                SizedBox(
                  width: width * 0.69,
                  child: Text('Superior Completion Services',
                      style: bigFontStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: width * 0.23,
                        child: Text('TPM job number:',
                            style: bigFontStyle.copyWith())),
                    SizedBox(
                        width: width * 0.69,
                        child: Text('7750',
                            style: bigFontStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline))),
//
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                  width: width * 0.23,
                  child:
                      Text('Part Description:', style: bigFontStyle.copyWith()),
                ),
                SizedBox(
                  width: width * 0.69,
                  child: Text('FIXED MESH 4" 250 UM,288" LG',
                      style: bigFontStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
//
//class DescriptionTextWidget extends StatefulWidget {
//  final String text;
//
//  DescriptionTextWidget({@required this.text});
//
//  @override
//  _DescriptionTextWidgetState createState() =>
//      new _DescriptionTextWidgetState();
//}
//
//class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
//  String firstHalf;
//  String secondHalf;
//
//  bool flag = true;
//
//  @override
//  void initState() {
//    super.initState();
//
//    if (widget.text.length > 50) {
//      firstHalf = widget.text.substring(0, 50);
//      secondHalf = widget.text.substring(50, widget.text.length);
//    } else {
//      firstHalf = widget.text;
//      secondHalf = "";
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
//      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//      child: secondHalf.isEmpty
//          ? new Text(firstHalf)
//          : new Column(
//              children: <Widget>[
//                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
//                new InkWell(
//                  child: new Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: <Widget>[
//                      new Text(
//                        flag ? "show more" : "Show less",
//                        style: new TextStyle(color: Colors.blue),
//                      ),
//                    ],
//                  ),
//                  onTap: () {
//                    setState(() {
//                      flag = !flag;
//                    });
//                  },
//                ),
//              ],
//            ),
//    );
//  }
//}
