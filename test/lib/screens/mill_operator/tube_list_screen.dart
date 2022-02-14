import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';

class TubeListScreen extends StatefulWidget {
  @override
  _TubeListScreenState createState() => _TubeListScreenState();
}

class _TubeListScreenState extends State<TubeListScreen> {
  String selectedDate = "";
  double height = 0;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text('Completed Tube List')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _getDatewiseTube("10-07-2020"),
              _getDatewiseTube("11-07-2020"),
              _getDatewiseTube("12-07-2020"),
            ],
          ),
        ));
  }

  Widget _getDatewiseTube(String date) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
      child: InkWell(
        onTap: () {
          if (selectedDate == date)
            setState(() {
              selectedDate = "";
            });
          else
            setState(() {
              selectedDate = date;
            });
        },
        child: Card(
          color: secondaryColor,
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        '$date',
                        style: bigBoldFontStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  )),
              if (selectedDate == date)
                SizedBox(
                  width: width * 0.97,
                  height: 110 * 2.0,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return tubewiseDetailsCard("007-001", 1);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tubewiseDetailsCard(String title, int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: InkWell(
          onTap: () {},
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
    );
  }
}
