import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusStationMap extends StatefulWidget {
  const BusStationMap({Key? key}) : super(key: key);

  @override
  _BusStationMapState createState() => _BusStationMapState();
}

class _BusStationMapState extends State<BusStationMap> {
  late BitmapDescriptor customIcon;
  bool mapToggle = false;
  var currentLocation;
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
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
    Map<dynamic, dynamic> dataset = markersList[0]['data'][0];
    // var dataset = markersList[0][0];
    dataset.forEach((k,v) => initMarker(v['name'], v['latitude'], v['longitude'], k, customIcon));
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

  getMapIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker.png');
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
                      markers: Set<Marker>.of(getMarkers().values),
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
