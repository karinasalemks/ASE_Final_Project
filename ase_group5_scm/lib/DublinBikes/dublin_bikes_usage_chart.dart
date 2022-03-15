import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DublinBikesUsageChart extends StatefulWidget {
  final snapshot;

  const DublinBikesUsageChart({Key? key, this.snapshot}) : super(key: key);

  @override
  _DublinBikesUsageChartState createState() => _DublinBikesUsageChartState();
}

Map getStationUsageData(snapshot) {
  Map stationUsageMap = new Map<String, double>();
  for (int i = 0; i < snapshot.docs.length; i++) {
    var stationName = snapshot.docs[i].get("station_name");
    var stationOccupancy = snapshot.docs[i].get("occupancy_list");
    var lastUpdateTime = snapshot.docs[i].get("harvest_time");
    DateTime now = DateTime.now();
    var timeDifference =
        now.difference(DateTime.parse(lastUpdateTime)).inMinutes;
    int index = (timeDifference / 5).round();
    int maxIndex = stationOccupancy.length - 1;
    if (index < maxIndex) {
      stationUsageMap[stationName] = stationOccupancy[index] * 100;
    } else {
      stationUsageMap[stationName] = stationOccupancy[maxIndex] * 100;
    }
  }
  return stationUsageMap;
}

List sortStationMaps(Map stationUsageMap) {
  //sort the map based on occupancy
  stationUsageMap = Map.fromEntries(stationUsageMap.entries.toList()
    ..sort((e1, e2) => e1.value.compareTo(e2.value)));

  List<BikeStationUsageData> stationUsageList = [];
  List<BikeStationUsageData> ascStationUsageList = [];
  List<BikeStationUsageData> descStationUsageList = [];

  //add the sorted map into a list of BikeStationUsageData objects
  stationUsageMap.entries.forEach((e) => stationUsageList.add(
      BikeStationUsageData(stationName: e.key, occupancyPercentage: e.value)));

  ascStationUsageList = stationUsageList.getRange(0, 10).toList();

  descStationUsageList = stationUsageList.reversed.toList().take(10).toList();

  var seriesArray = [ascStationUsageList, descStationUsageList];
  return seriesArray;
}

String getInitials(String sName) {
  //get the initials of the station name
  var stationName = sName.split(" ");
  var stationInitials = "";
  for (var i = 0; i < stationName.length; i++) {
    //check if first letter in word is a bracket, take the second letter
    stationInitials += stationName[i][0]=='('?stationName[i][1]:stationName[i][0];
  }
  return stationInitials;
}

class BikeStationUsageData {
  String stationName;
  double occupancyPercentage;

  BikeStationUsageData({
    required this.stationName,
    required this.occupancyPercentage,
  });
}

class _DublinBikesUsageChartState extends State<DublinBikesUsageChart> {
  Map stationUsageMap = new Map<String, double>();
  bool toogleState = false;

  List<bool> isSelected = [true, false];

  late List<BikeStationUsageData> stationUsageList;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map stationUsageMap = getStationUsageData(widget.snapshot);
    var seriesArray = sortStationMaps(stationUsageMap);
    if (isSelected[0]) {
      stationUsageList = seriesArray[0];
    } else {
      stationUsageList = seriesArray[1];
    }
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        // Templating the tooltip
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          return Container(
              padding: const EdgeInsets.all(3),
              child: Text(
                'Station Name : ${stationUsageList[pointIndex].stationName} \n'
                'Station Occupancy: ${stationUsageList[pointIndex].occupancyPercentage.toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ));
        });

    return Container(
      height: MediaQuery.of(context).size.height * 0.5 - 40,
      // width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Dublin Bikes Usage Chart",
              ),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                      labelRotation: 30,
                      majorGridLines: MajorGridLines(width: 0)),
                  primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      maximum: stationUsageList
                          .map<double>((e) => e.occupancyPercentage)
                          .reduce(max)),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ColumnSeries<BikeStationUsageData, String>>[
                    ColumnSeries<BikeStationUsageData, String>(
                      dataSource: stationUsageList,
                      xValueMapper:
                          (BikeStationUsageData bikeStationUsageData, _) =>
                              getInitials(bikeStationUsageData.stationName),
                      yValueMapper:
                          (BikeStationUsageData bikeStationUsageData, _) =>
                              bikeStationUsageData.occupancyPercentage,
                      enableTooltip: true,
                    ),
                  ],
                ),
              ),
              new Row(
                children: <Widget>[
                  ToggleButtons(
                    borderColor: Colors.black,
                    fillColor: Colors.grey,
                    borderWidth: 2,
                    selectedBorderColor: Colors.black,
                    selectedColor: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Overuse Stations',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Underuse Stations',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                          if (isSelected[0] && !toogleState) {
                            toogleState = true;
                            stationUsageList = seriesArray[0];
                          } else if (isSelected[1] && toogleState) {
                            toogleState = false;
                            stationUsageList = seriesArray[1];
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
