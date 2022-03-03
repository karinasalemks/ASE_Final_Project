import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ase_group5_scm/DublinBikes/dublin_bikes_usage_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DublinBikesUsageChart extends StatefulWidget {
  const DublinBikesUsageChart({Key? key}) : super(key: key);

  @override
  _DublinBikesUsageChartState createState() => _DublinBikesUsageChartState();
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
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('DublinBikes')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                Map stationUsageMap = getStationUsageData(snapshot);
                // for (int i = 0; i < snapshot.data!.docs.length; i++) {
                //   getStationUsageData(snapshot.data!.docs[i]);
                // }

                var seriesArray = sortStationMaps(stationUsageMap);

                if (isSelected[0]) {
                  StationUsageMapListSeries = seriesArray[0];
                } else {
                  StationUsageMapListSeries = seriesArray[1];
                }

                return Scaffold(
                  body: Center(
                      child: Container(
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
                                  renderSpec: charts.SmallTickRendererSpec(
                                      labelRotation: 60),
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
                                      for (int i = 0;
                                          i < isSelected.length;
                                          i++) {
                                        isSelected[i] = i == index;
                                        if (isSelected[0] && !toogleState) {
                                          toogleState = true;
                                          StationUsageMapListSeries =
                                              seriesArray[0];
                                        } else if (isSelected[1] &&
                                            toogleState) {
                                          toogleState = false;
                                          StationUsageMapListSeries =
                                              seriesArray[1];
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
                  )),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Snapshot has Error!");
              } else {
                return Center(
                    child: Transform.scale(
                  scale: 1,
                  child: CircularProgressIndicator(),
                ));
              }
            }));
  }
}
