import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class BusStationMap extends StatefulWidget {
  const BusStationMap({Key? key}) : super(key: key);

  @override
  _BusStationMapState createState() => _BusStationMapState();
}

class _BusStationMapState extends State<BusStationMap> {
  late BitmapDescriptor customIcon;
  bool mapToggle = false;
  var currentLocation;
  late Map<dynamic, dynamic> dataset;
  late var dataset_trip_list;
  late GoogleMapController mapController;

  double _originLatitude = 53.3397, _originLongitude = -6.2566;
  double _destLatitude = 53.3492, _destLongitude = -6.2596;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAGUwl_spXiMnoxkDmPpAj0sVsfccchDjY";

  AppBar appBar = AppBar(
    title: Text("Dublin Bus Map"),
  );

  getMarkerData() async {
    FirebaseFirestore.instance.collection('DublinBus').get().then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        Map<dynamic, dynamic> dataset = myMarkers.docs[0].get(0);
        dataset.entries.forEach((element) {
          var station_id = element.key();
          var station_latitude = element.value().get('latitude');
          var station_longitude = element.value().get('longitude');
          var station_name = element.value().get('name');
          initMarker(station_name, station_latitude, station_longitude,
              station_id, customIcon);
        });
      }
    });
  }

  void initAllMarkers(var markersList) {
    // markers.clear();
     dataset = markersList[0]['data'][0];
    // var dataset = markersList[0][0];
    dataset.forEach((k,v) => initMarker(v['name'], v['latitude'], v['longitude'], k, customIcon));
    dataset_trip_list = markersList[2]['data'][0]['stop_sequences'];

     double origin_lat= dataset[dataset_trip_list[0]]['latitude'];
     double origin_longi= dataset[dataset_trip_list[0]]['longitude'];

     double dest_lat= dataset[dataset_trip_list[dataset_trip_list.length-1]]['latitude'];
     double dest_longi= dataset[dataset_trip_list[dataset_trip_list.length-1]]['longitude'];
    List wayPoint = [];
    for(int i=1;i<dataset_trip_list.length-1;i++){
      double lat= dataset[dataset_trip_list[i]]['latitude'];
      double longi= dataset[dataset_trip_list[i]]['longitude'];
      wayPoint.add(PolylineWayPoint(location: '$lat,$longi',stopOver: true));
    }
    _getPolyline(origin_lat, origin_longi, dest_lat, dest_longi, wayPoint);

     // var dataset_trips= markersList[1]['data'];
     // for(int i=0;i<dataset_trips.length;i++){
     //   var routes=dataset_trips[i]['stop_sequences'];
     //   for(int j=0;)
     // }

  }

  void initMarker(
      station_name, station_latitude, station_longitude, stationID, inputIcon) {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    // var busStand = stationData.get("available_busStands")[0];
    // var freeBuses = stationData.get("available_buses")[0];
    // var totalBuses = busStand + freeBuses;
    // busStand = busStand.toString();
    // freeBuses = freeBuses.toString();
    // totalBuses = totalBuses.toString();
    final Marker marker = Marker(
        markerId: markerId,
        icon: inputIcon,
        position: LatLng(double.parse(station_latitude.toString()),
            double.parse(station_longitude.toString())),
        infoWindow: InfoWindow(title: station_name)
        // snippet: "Total Stands:$totalBuses\nAvailable Stands: $busStand\nAvailable Buses: $freeBuses"),
        );
    markers[markerId] = marker;
  }

  Map<MarkerId, Marker> getMarkers() {
    return markers;
  }

  @override
  void initState() {
    getMapIcon();
    //getMarkerData();

    setState(() {
      mapToggle = true;
    });
    super.initState();
    /// origin marker
   // _getPolyline();



  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(var orig_lati,var orig_longi,var dest_lati, var dest_longi, var wayPointList) async {
    print('Hello Inside result');

    _addMarker(LatLng(orig_lati, orig_longi), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(dest_lati, dest_longi), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(orig_lati,orig_longi),
        PointLatLng(dest_lati,dest_longi),
        travelMode: TravelMode.driving,
        wayPoints: wayPointList);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  getMapIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus_station_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    var heightOfFilter =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
            0.10;
    //Todo: Refine the code here to stop calling setState method before build.
    return Scaffold(
      //appBar: appBar,
      resizeToAvoidBottomInset: false,
      drawer: SideMenu(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('DublinBus').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            initAllMarkers(snapshot.data!.docs);
            return Column(
              children: <Widget>[
                new Container(
                    height: heightOfFilter,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text('Current Station Occupancy',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ))),
                new Container(
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            heightOfFilter) *
                        0.90,
                    key: Key("dublin-buses-map"),
                    child: GoogleMap(
                      onMapCreated: onMapCreated,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(53.344007, -6.266802),
                        zoom: 15.0,
                      ),
                      // polylines: polyline,
                      markers: Set<Marker>.of(getMarkers().values),
                      polylines: Set<Polyline>.of(polylines.values),
                    )),
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error pa thambi! :)");
          } else {
            return Center(
                child: Transform.scale(
              scale: 1,
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
