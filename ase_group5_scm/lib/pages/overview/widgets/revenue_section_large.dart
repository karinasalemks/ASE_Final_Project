import 'package:ase_group5_scm/pages/overview/widgets/correlation_analysis.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/widgets/custom_text.dart';

late List<dynamic> dry_data = [];
late List<FlSpot> wetCorrelation = [];

class RevenueSectionLarge extends StatefulWidget {
  const RevenueSectionLarge({Key? key}) : super(key: key);

  @override
  _RevenueSectionLargeState createState() => _RevenueSectionLargeState();
}

class _RevenueSectionLargeState extends State<RevenueSectionLarge> {

  String dropdownvalue = 'Dry day vs Rainy day';
  var filterList = [
    'Dry day vs Rainy day',
    'high temp vs low temp',
    'high wind vs low wind',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 6),
                color: lightGrey.withOpacity(.1),
                blurRadius: 12)
          ],
          border: Border.all(color: lightGrey, width: .5),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              CustomText(
              text: "Correlation - Bikes volume of usage based on weather",
              size: 20,
              weight: FontWeight.bold,
              color: lightGrey,
            ),
            Container(
              child: DropdownButton(
                value: dropdownvalue,
                icon: Icon(Icons.keyboard_arrow_down),
                items: filterList.map((String items) {
                  return DropdownMenuItem(value: items, child: Text(items));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                    // initAllMarkers(snapshot.data!.docs);
                  });
                },
              ),
            ),
            Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  height: 400,
                  child: correlationWidget(
                      correlation_key: filterList.indexOf(dropdownvalue)),
                  // width: 600,
                  // height: 200,
                  // child: SimpleBarChart.withSampleData()
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  height: 400,
                  child: correlationWidget(
                      correlation_key: filterList.indexOf(dropdownvalue)+3),
                  // width: 600,
                  // height: 200,
                  // child: SimpleBarChart.withSampleData()
                ),
              ],
            )
            )]),
          ),
        ]));
  }
}


