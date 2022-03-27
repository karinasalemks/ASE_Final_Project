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
  //TODO: figure out how to stop the original list from changing
  List<BikeStationUsageData> initAscStationUsageList = [];
  initAscStationUsageList = getInitializedStationName([...ascStationUsageList]);

  descStationUsageList = stationUsageList.reversed.toList().take(10).toList();
  List<BikeStationUsageData> initDescStationUsageList =
  getInitializedStationName(descStationUsageList);

  // List<charts.Series<BikeStationUsageData, String>> ascStationUsageSeries =
  //     getListSeries(initAscStationUsageList);
  // List<charts.Series<BikeStationUsageData, String>> decStationUsageSeries =
  //     getListSeries(initDescStationUsageList);

  // var seriesArray = [ascStationUsageSeries, decStationUsageSeries];
  // var seriesArray = [decStationUsageSeries, ascStationUsageSeries];
  var seriesArray = [
    initAscStationUsageList,
    initDescStationUsageList,
    ascStationUsageList,
    descStationUsageList
  ];
  return seriesArray;
}

// TODO: Need unique Names passed to Charts. Try getting first word and then initials. Also parenthesis bug. Kevin&Karina
List<BikeStationUsageData> getInitializedStationName(
    List<BikeStationUsageData> stationUsageList) {
  List<BikeStationUsageData> initStationUsageList = [];
  for (var i = 0; i < stationUsageList.length; i++) {
    BikeStationUsageData bikeStationUsageData = new BikeStationUsageData(stationName: stationUsageList[i].stationName, occupancyPercentage:  stationUsageList[i].occupancyPercentage);
    var stationName = bikeStationUsageData.stationName.split(" ");
    print(stationName);
    var stationInitials = "";
    for (var i = 0; i < stationName.length; i++) {
      if(i < 2) {
        stationInitials += stationName[i][0];
      }
    }
    bikeStationUsageData.stationName = stationInitials;
    bikeStationUsageData.occupancyPercentage =
    bikeStationUsageData.occupancyPercentage == null
        ? 0
        : bikeStationUsageData.occupancyPercentage;
    initStationUsageList.add(bikeStationUsageData);
  }
  return initStationUsageList;
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
  late List<BikeStationUsageData> stationFullNameList;
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
      // StationUsageMapListSeries = [];
      // StationUsageMapListSeries = seriesArray[0];
      stationFullNameList = seriesArray[2];

      stationUsageList = seriesArray[0];
    } else {
      // StationUsageMapListSeries = [];
      // StationUsageMapListSeries = seriesArray[1];
      stationFullNameList = seriesArray[3];
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
                'Station Name : ${stationFullNameList[pointIndex].stationName} \n'
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
                      bikeStationUsageData.stationName,
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