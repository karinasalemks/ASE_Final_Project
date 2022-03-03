import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DublinBikesUsageChart extends StatefulWidget {
  final snapshot;

  const DublinBikesUsageChart({Key? key, this.snapshot}) : super(key: key);

  @override
  _DublinBikesUsageChartState createState() => _DublinBikesUsageChartState();
}

Map getStationUsageData(snapshot) {
  Map stationUsageMap = new Map<String, double>();
  for (int i = 0; i < snapshot.data!.docs.length; i++) {
    var stationName = snapshot.data!.docs[i].get("station_name");
    var stationOccupancy = snapshot.data!.docs[i].get("occupancy_list");
    var lastUpdateTime = snapshot.data!.docs[i].get("harvest_time");
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
  List<BikeStationUsageData> decStationUsageList = [];

  //add the sorted map into a list of BikeStationUsageData objects
  stationUsageMap.entries.forEach((e) => stationUsageList.add(
      BikeStationUsageData(stationName: e.key, occupancyPercentage: e.value)));

  ascStationUsageList = stationUsageList.getRange(0, 10).toList();

  decStationUsageList =
      stationUsageList.reversed.toList().getRange(0, 10).toList();

  List<charts.Series<BikeStationUsageData, String>> ascStationUsageSeries =
      getListSeries(ascStationUsageList);
  List<charts.Series<BikeStationUsageData, String>> decStationUsageSeries =
      getListSeries(decStationUsageList);
  var seriesArray = [ascStationUsageSeries, decStationUsageSeries];
  return seriesArray;
}

List<charts.Series<BikeStationUsageData, String>> getListSeries(
    List<BikeStationUsageData> stationUsageMapList) {
  List<charts.Series<BikeStationUsageData, String>> stationUsageMapListSeries =
      [
    charts.Series(
      id: "Bike Usage Percentage",
      data: stationUsageMapList,
      domainFn: (BikeStationUsageData stationUsageMapListSeries, _) =>
          stationUsageMapListSeries.stationName,
      measureFn: (BikeStationUsageData stationUsageMapListSeries, _) =>
          stationUsageMapListSeries.occupancyPercentage,
    )
  ];
  return stationUsageMapListSeries;
}

class BikeStationUsageData {
  final String stationName;
  final double occupancyPercentage;
  BikeStationUsageData({
    required this.stationName,
    required this.occupancyPercentage,
  });
}

class _DublinBikesUsageChartState extends State<DublinBikesUsageChart> {
  Map stationUsageMap = new Map<String, double>();
  bool toogleState = false;

  List<bool> isSelected = [true, false];
  late List<charts.Series<BikeStationUsageData, String>>
  StationUsageMapListSeries;

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
      StationUsageMapListSeries = seriesArray[0];
    } else {
      StationUsageMapListSeries = seriesArray[1];
    }
    return Container(
      height: 600,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Dublin Bikes Usage Chart",
              ),
              Expanded(
                child: charts.BarChart(
                  StationUsageMapListSeries,
                  animate: false,
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
                  ),
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
                            StationUsageMapListSeries = seriesArray[0];
                          } else if (isSelected[1] && toogleState) {
                            toogleState = false;
                            StationUsageMapListSeries = seriesArray[1];
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
