import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

late List<dynamic> dry_data;

late List<dynamic> hT_data;

late List<dynamic> hW_data;

late List<dynamic> lT_data;

late List<dynamic> lW_data;

late List<dynamic> rain_data;

late List<List<FlSpot>> data = [];
// late List<FlSpot> high_temp = [];
// late List<FlSpot> high_wind = [];
// late List<FlSpot> low_temp = [];
// late List<FlSpot> low_wind = [];
// late List<FlSpot> rain = [];

class correlationWidget extends StatefulWidget {
  final correlation_key;

  const correlationWidget({Key? key, this.correlation_key}) : super(key: key);

  @override
  _correlationWidgetState createState() => _correlationWidgetState();
}

formatData(var argument) {
  if (argument.docs.isNotEmpty) {
    dry_data = argument.docs[0]['data']['dry'];
    hT_data = argument.docs[0]['data']['high_temp'];
    hW_data = argument.docs[0]['data']['high_wind'];
    lT_data = argument.docs[0]['data']['low_temp'];
    lW_data = argument.docs[0]['data']['low_wind'];
    rain_data = argument.docs[0]['data']['rain'];

    data.add(dry_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
    data.add(hT_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
    data.add(hW_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
    data.add(rain_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
    data.add(lT_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
    data.add(lW_data.asMap().entries.map((element) {
      return FlSpot(element.key.toDouble(), element.value);
    }).toList());
  }
}

getCorelationData() {
  FirebaseFirestore.instance
      .collection(AppConstants.CORRELATION_OVERVIEW)
      .get()
      .then((argument) {
    formatData(argument);
  });
}

class _correlationWidgetState extends State<correlationWidget> {
  get correlation_key => null;

  @override
  void initState() {
    // TODO: implement initState
    print('inside init state');
    getCorelationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data.length != 0?Container(
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          maxY: 1.0,
          axisTitleData:FlAxisTitleData(leftTitle: AxisTitle(titleText: "volume of usage",showTitle:true,margin: 2.0), bottomTitle: AxisTitle(titleText: "Hours", showTitle:true,margin: 30.0) ),
          lineBarsData: [
            // The red line
            LineChartBarData(
                spots: data[widget.correlation_key], colors: [(widget.correlation_key <3 ?Colors.red: Colors.blue)]),
          ],
        ),
      ),
    ):CircularProgressIndicator();
  }
}
