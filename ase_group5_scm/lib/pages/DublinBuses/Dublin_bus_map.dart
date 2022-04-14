import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class BusStationMap extends StatefulWidget {
  const BusStationMap({Key? key}) : super(key: key);

  @override
  _BusStationMapState createState() => _BusStationMapState();
}

class _BusStationMapState extends State<BusStationMap> {
  late BitmapDescriptor low;
  late BitmapDescriptor medium;
  late BitmapDescriptor high;
  late BitmapDescriptor higher;
  late BitmapDescriptor highest;
  bool mapToggle = false;
  var currentLocation;
  late Map<dynamic, dynamic> dataset;
  late Map<dynamic, dynamic> dataset_busiest_trips;
  late var dataset_trip_list;
  late var dataset_trips_test;
  late GoogleMapController mapController;
  bool flag = false;
  List<bool> isSelected = [true, false];
  bool toggleState = true;
  late var checkmarkerbus = null;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers_dummy = {};
  Map<PolylineId, Polyline> polylines = {};
  Map<PolylineId, Polyline> polylines_dummy = {};
  Map<CircleId, Circle> _circles = {};
  Map<CircleId, Circle> _circles_dummy = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAGUwl_spXiMnoxkDmPpAj0sVsfccchDjY";
  var _circleIdCounter = 0;
  var _polylineCount = 0;

  AppBar appBar = AppBar(
    title: Text("Dublin Bus Map"),
  );

  getMarkerData() {
    FirebaseFirestore.instance.collection('DublinBus').get().then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        initAllMarkers(myMarkers.docs);
      }
    });
  }

  void initAllMarkers(var markersList) {
    markers.clear();
    polylines.clear();
    dataset = markersList[0]['data'][0];
    int counter = 0;
    for (var k in dataset.entries) {
      if (counter < 100) {
        initMarker(k.value['name'], k.value['latitude'], k.value['longitude'],
            k.key, medium);
      }
      counter++;
    }
    dataset_busiest_trips = markersList[1]['data'];

    dataset_busiest_trips.forEach((k, v) => add_new_marker(k, v));
    dataset_trips_test = markersList[2]['data'];
    for (int i = 0; i < 4; i++) {
      dataset_trip_list = markersList[2]['data'][i]['stop_sequences'];

      double origin_lat = dataset[dataset_trip_list[0]]['latitude'];
      double origin_longi = dataset[dataset_trip_list[0]]['longitude'];

      double dest_lat =
          dataset[dataset_trip_list[dataset_trip_list.length - 1]]['latitude'];
      double dest_longi =
          dataset[dataset_trip_list[dataset_trip_list.length - 1]]['longitude'];
      List<PolylineWayPoint> wayPoint = [];

      int k = 1;
      while (k < dataset_trip_list.length - 2) {
        if (k == 22) break;
        double lat = dataset[dataset_trip_list[k]]['latitude'];
        double longi = dataset[dataset_trip_list[k]]['longitude'];
        wayPoint.add(PolylineWayPoint(location: '$lat,$longi'));
        k++;
      }
      _getPolyline(origin_lat, origin_longi, dest_lat, dest_longi, wayPoint);
    }
    checkmarkerbus = 8;
  }

  void add_new_marker(var id, var part_of_trips) {
    _setCircles(LatLng(dataset[id]['latitude'], dataset[id]['longitude']),
        part_of_trips * 5);
    if (part_of_trips >= 10 && part_of_trips <= 15) {
      initMarker(dataset[id]['name'], dataset[id]['latitude'],
          dataset[id]['longitude'], id, high);
    } else if (part_of_trips <= 20) {
      initMarker(dataset[id]['name'], dataset[id]['latitude'],
          dataset[id]['longitude'], id, higher);
    } else {
      initMarker(dataset[id]['name'], dataset[id]['latitude'],
          dataset[id]['longitude'], id, highest);
    }
  }

  void initMarker(
      station_name, station_latitude, station_longitude, stationID, inputIcon) {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        icon: inputIcon,
        position: LatLng(double.parse(station_latitude.toString()),
            double.parse(station_longitude.toString())),
        infoWindow: InfoWindow(title: station_name));
    markers[markerId] = marker;
  }

  Map<MarkerId, Marker> getMarkers() {
    return markers;
  }

  @override
  void initState() {
    getMapIcon();
    getMarkerData();
    isSelected = [true, false];
    super.initState();
    setState(() {
      polylines.clear();
      mapToggle = true;
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _setCircles(LatLng point, var rad) {
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    CircleId id = CircleId(circleIdVal);
    _circles[id] = Circle(
        circleId: CircleId(circleIdVal),
        center: point,
        radius: rad,
        fillColor: Colors.redAccent.withOpacity(0.5),
        strokeWidth: 3,
        strokeColor: Colors.redAccent);
    setState(() {});
  }

  _addPolyLine() {
    print('Hello Inside _addPolyLine Function');
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 4);
    polylines[id] = polyline;
    setState(() {
      _polylineCount++;
    });
  }

  _getPolyline(var orig_lati, var orig_longi, var dest_lati, var dest_longi,
      var wayPointList) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(orig_lati, orig_longi),
        PointLatLng(dest_lati, dest_longi),
        travelMode: TravelMode.driving,
        optimizeWaypoints: true,
        wayPoints: wayPointList);
    polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  getMapIcon() async {
    low = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus-station_marker_0.png');
    medium = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus-station_marker_1.png');
    high = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus-station_marker_2.png');
    higher = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus-station_marker_3.png');
    highest = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus-station_marker_4.png');
  }

  bikeMapHeaderContainer(heightOfFilter) {
    return new Container(
        height: heightOfFilter,
        child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                ToggleButtons(
                  borderColor: Colors.white,
                  fillColor: Colors.blue,
                  borderWidth: 2,
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Bus Stations',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'CO2 Emissions',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                        if (isSelected[0] && !toggleState) {
                          toggleState = true;
                        } else if (isSelected[1] && toggleState) {
                          toggleState = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected,
                ),
              ],
            )));
  }

  bikesMapContainer(heightOfFilter) {
    return new Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                heightOfFilter -
                10) *
            0.90,
        key: Key("dublin-bikes-map"),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(53.344007, -6.266802),
            zoom: 15.0,
          ),
          markers: toggleState == true
              ? Set<Marker>.of(getMarkers().values)
              : Set<Marker>.of(markers_dummy.values),
          polylines: toggleState == false
              ? Set<Polyline>.of(polylines.values)
              : Set<Polyline>.of(polylines_dummy.values),
          circles: toggleState == false
              ? Set<Circle>.of(_circles.values)
              : Set<Circle>.of(_circles_dummy.values),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var heightOfFilter =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
            0.10;
    //Todo: Refine the code here to stop calling setState method before build.
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height - heightOfFilter,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  bikeMapHeaderContainer(heightOfFilter),
                  bikesMapContainer(heightOfFilter),
                ],
              ))),
    );
  }
}
