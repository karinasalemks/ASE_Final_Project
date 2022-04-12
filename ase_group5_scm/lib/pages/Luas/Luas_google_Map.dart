import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LuasStationMap extends StatefulWidget {
  const LuasStationMap({Key? key}) : super(key: key);

  @override
  _LuasStationMapState createState() => _LuasStationMapState();
}

class _LuasStationMapState extends State<LuasStationMap> {
  late BitmapDescriptor low;
  bool mapToggle = false;
  var currentLocation;
  late Map<dynamic, dynamic> dataset;
  late Map<dynamic, dynamic> dataset_trams;
  late GoogleMapController mapController;
  bool flag = false;
  List<bool> isSelected = [true, false];
  bool toggleState = true;


  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers_dummy = {};


  AppBar appBar = AppBar(
    title: Text("Dublin Luas Map"),
  );

  getMarkerData() {
    FirebaseFirestore.instance.collection('DublinLuas').get().then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        initAllMarkers(myMarkers.docs);
      }
    });
  }


  void initAllMarkers(var markersList) {
    markers.clear();
    dataset = markersList[0]['data'];
    //var dataset = markersList[0][0];
    dataset_trams = markersList[1]['data']['luas_data'];


    dataset.forEach((k, v) =>
        initMarker(
            v['name'],
            v['Latitude'],
            v['Longitude'],
            k,
            dataset_trams[k]['inboundTramsCount'],
            dataset_trams[k]['outboundTramsCount'],
            dataset_trams[k]['line'],
            low));
  }

  void initMarker(station_name, station_latitude, station_longitude, stationID,
      station_in_count, station_out_count, line, inputIcon) {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      icon: inputIcon,
      position: LatLng(double.parse(station_latitude.toString()),
          double.parse(station_longitude.toString())),
      infoWindow: InfoWindow(title: station_name,
          snippet:
          "Inbound Count:$station_in_count\nOutbound Count: $station_out_count\nLine: $line"),
    );
    markers[markerId] = marker;
  }

  Map<MarkerId, Marker> getMarkers() {
    return markers;
  }

  @override
  void initState() {
    getMapIcon();
    getMarkerData();
    // isSelected = [true, false];
    super.initState();
    setState(() {
      mapToggle = true;
    });

    /// origin marker
    // _getPolyline();


  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }


  getMapIcon() async {
    low = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/luas_station_1.png');
  }


  // bikeMapHeaderContainer(heightOfFilter) {
  //   return new Container(
  //       height: heightOfFilter,
  //       child: Padding(
  //           padding: const EdgeInsets.only(top: 10.0),
  //           child: Row(
  //             children: <Widget>[
  //               ToggleButtons(
  //                 borderColor: Colors.black,
  //                 fillColor: Colors.grey,
  //                 borderWidth: 2,
  //                 selectedBorderColor: Colors.black,
  //                 selectedColor: Colors.white,
  //                 borderRadius: BorderRadius.circular(0),
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       'Bus Stations',
  //                       style: TextStyle(fontSize: 16),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       'CO2 Emissions',
  //                       style: TextStyle(fontSize: 16),
  //                     ),
  //                   ),
  //                 ],
  //                 onPressed: (int index) {
  //                   setState(() {
  //                     for (int i = 0; i < isSelected.length; i++) {
  //                       isSelected[i] = i == index;
  //                       if (isSelected[0] && !toggleState) {
  //                         toggleState = true;
  //
  //                       } else if (isSelected[1] && toggleState) {
  //                         toggleState = false;
  //
  //                       }
  //                     }
  //                   });
  //                 },
  //                 isSelected: isSelected,
  //               ),
  //             ],
  //           )));
  // }

  LuasMapContainer(heightOfFilter) {
    return new Container(
        height: (MediaQuery
            .of(context)
            .size
            .height -
            appBar.preferredSize.height -
            heightOfFilter) *
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

        ));
  }

  @override
  Widget build(BuildContext context) {
    var heightOfFilter =
        (MediaQuery
            .of(context)
            .size
            .height - appBar.preferredSize.height) *
            0.10;
    //Todo: Refine the code here to stop calling setState method before build.

    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery
          .of(context)
          .size
          .height - heightOfFilter,
      child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  //bikeMapHeaderContainer(heightOfFilter),
                  LuasMapContainer(heightOfFilter),
                ],
              ))),
    );
  }
}