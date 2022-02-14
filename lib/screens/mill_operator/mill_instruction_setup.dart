import 'package:flutter/material.dart';
import 'package:tpmapp/constants/my_style.dart';
import 'package:tpmapp/constants/routes_name.dart';

class MillInstSetup extends StatefulWidget {
  @override
  _MillInstSetupState createState() => _MillInstSetupState();
}

class _MillInstSetupState extends State<MillInstSetup> {
  double height = 0;
  double width = 0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text('Mill Inspection before setup')),
        body: Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text('1. Clean mill table and area ', style: bigBoldFontStyle),
                SizedBox(height: 5),
                Text('2. Receive setup paperwork ', style: bigBoldFontStyle),
                SizedBox(height: 5),
                Text('3. Check steel for straightness ',
                    style: bigBoldFontStyle),
                SizedBox(height: 5),
                Text('4. Inspect die and clamps ', style: bigBoldFontStyle),
                SizedBox(height: 5),
                Text('5. Check level of front plate  ',
                    style: bigBoldFontStyle),
                SizedBox(height: 5),
                Text('6. Check that table is level ', style: bigBoldFontStyle),
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
        ));
  }

  Widget _getJobCard(String job, String part, String customer) {
    return Container(
      width: width,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 3, 8, 3),
          child: Card(
            color: secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job #$job',
                    style: bigFontStyle.copyWith(
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    'Part #$part',
                    style: bigFontStyle.copyWith(color: primaryColor),
                  ),
                  Text(
                    'Customer: $customer',
                    style: bigFontStyle.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _safetyList() {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text('1. Clean mill table and area ', style: bigBoldFontStyle),
            SizedBox(height: 5),
            Text('2. Receive setup paperwork ', style: bigBoldFontStyle),
            SizedBox(height: 5),
            Text('3. Check steel for straightness ', style: bigBoldFontStyle),
            SizedBox(height: 5),
            Text('4. Inspect die and clamps ', style: bigBoldFontStyle),
            SizedBox(height: 5),
            Text('5. Check level of front plate  ', style: bigBoldFontStyle),
            SizedBox(height: 5),
            Text('6. Check that table is level ', style: bigBoldFontStyle),
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
    );
  }
}
