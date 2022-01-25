import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:geolocator/geolocator.dart';

class BikeStationMap extends StatefulWidget {
  const BikeStationMap({Key? key}) : super(key: key);

  @override
  _BikeStationMapState createState() => _BikeStationMapState();
}

class _BikeStationMapState extends State<BikeStationMap> {
  bool mapToggle = false;

  var currentLocation;

  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('DublinBikes')
        .get()
        .then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        for (int i = 0; i < myMarkers.docs.length; i++) {
          initMarker(myMarkers.docs[i], myMarkers.docs[i].id);
        }
      }
    });
  }

  void initMarker(stationData, stationID) async {
    setState(() {
      var markerIdVal = stationID;
      final MarkerId markerId = MarkerId(markerIdVal);
      var bikeStand = stationData.get("available_bike_stands").toString();
      var freeBikes = stationData.get("available_bikes")[0].toString();
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(stationData.get("latitude")),
            double.parse(stationData.get("longitude"))),
        infoWindow: InfoWindow(
            title: stationData.get("station_name"),
            snippet: "Stands: $bikeStand | Bikes: $freeBikes"),
      );
      markers[markerId] = marker;
    });
  }

  void initState() {
    //getMarkerData();
    super.initState();
    setState(() {
      mapToggle = true;
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Todo: Refine the code here to stop calling setState method before build.
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream:
        FirebaseFirestore.instance.collection('DublinBikes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              initMarker(snapshot.data!.docs[i], snapshot.data!.docs[i].id);
            }
            return GoogleMap(
              onMapCreated: onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(53.344007, -6.266802),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(markers.values),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error pa thambi!");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}