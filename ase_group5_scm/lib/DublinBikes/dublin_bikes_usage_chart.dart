import 'package:charts_flutter/flutter.dart' as charts;
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
  Map stationInitialNameMap = new Map<String, double>();
  // for (int i = 0; i < snapshot.data!.docs.length; i++) {
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

List<BikeStationUsageData> getInitializedStationName(
    List<BikeStationUsageData> stationUsageList) {
  List<BikeStationUsageData> initStationUsageList = [];
  for (var i = 0; i < stationUsageList.length; i++) {
    BikeStationUsageData bikeStationUsageData = stationUsageList[i];
    var stationName = bikeStationUsageData.stationName.split(" ");
    var stationInitials = "";
    for (var i = 0; i < stationName.length; i++) {
      stationInitials += stationName[i][0];
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
      // stationUsageMapListSeries.occupancyPercentage,
    )
  ];
  return stationUsageMapListSeries;
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
  late List<charts.Series<BikeStationUsageData, String>>
      StationUsageMapListSeries;
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
              child: Text(
            'PointIndex : ${stationFullNameList[pointIndex].stationName}',
            style: TextStyle(color: Colors.white),
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
                  primaryXAxis: CategoryAxis(),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ColumnSeries<BikeStationUsageData, String>>[
                    ColumnSeries<BikeStationUsageData, String>(
                      // Binding the chartData to the dataSource of the column series.
                      dataSource: stationUsageList,
                      name: 'BikeStationUsageData',
                      // xValueMapper: (BikeStationUsageData sales, _) => sales.stationName,
                      xValueMapper: (BikeStationUsageData sales, _) =>
                          sales.stationName,
                      yValueMapper: (BikeStationUsageData sales, _) =>
                          sales.occupancyPercentage,
                      enableTooltip: true,
                      // dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: charts.BarChart(
              //     StationUsageMapListSeries,
              //     animate: false,
              //     defaultRenderer: new charts.BarRendererConfig(
              //       maxBarWidthPx: 10,
              //       strokeWidthPx: 1.0,
              //       barGroupInnerPaddingPx: 0,
              //     ),
              //     domainAxis: charts.OrdinalAxisSpec(
              //       renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
              //     ),
              //   ),
              // ),
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
