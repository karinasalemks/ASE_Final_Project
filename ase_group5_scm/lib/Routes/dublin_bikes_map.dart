import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // new
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

  Map<MarkerId , Marker> markers = <MarkerId , Marker>{};

  getMarkerData() async {
    FirebaseFirestore.instance.collection('DublinBikesStationMarkers').get().then((myMarkers) {
      if(myMarkers.docs.isNotEmpty) {
        for(int i = 0; i < myMarkers.docs.length ; i++){
          initMarker(myMarkers.docs[i],myMarkers.docs[i].id);
        }
      }
    });
  }

  void initMarker(stationData , stationID) async {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(stationData.get("Latitude")), double.parse(stationData.get("Longitude"))),
      infoWindow: InfoWindow(title: stationData.get("Name") , snippet: "Available Bikes: 20"),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void initState() {
    getMarkerData();
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
    return Container(
        height: MediaQuery.of(context).size.height*0.70,
        width: double.infinity,
        child: mapToggle ?
        GoogleMap(
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(target: LatLng(53.344007, -6.266802),
            zoom: 15.0,
          ),
          markers: Set<Marker>.of(markers.values),
        ):
        Center(child: CircularProgressIndicator(),
        )
    );
  }
}