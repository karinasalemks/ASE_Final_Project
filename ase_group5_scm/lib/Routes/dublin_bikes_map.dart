import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BikeStationMap extends StatefulWidget {
  const BikeStationMap({Key? key}) : super(key: key);

  @override
  _BikeStationMapState createState() => _BikeStationMapState();
}

class _BikeStationMapState extends State<BikeStationMap> {
  bool mapToggle = false;
  var currentLocation;
  var filterList = [
    'All Stations',
    'More than 90% full',
    'More than 90% empty',
  ]; //station occupancy filter list
  String dropdownvalue =
      'All Stations'; // the default value for the station occupancy filter

  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  AppBar appBar = AppBar(
    title: Text("Dublin Bikes Map"),
  );
  //is not used.
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

  /*
  * This function initializes all the markers from the data received from firebase
  * it is also used in filtering based on station occupancy
  * */
  void initAllMarkers(var markersList) {
    markers.clear();
    for (int i = 0; i < markersList.length; i++) {
      if (dropdownvalue == filterList[0])
        initMarker(markersList[i], markersList[i].id);
      else if (dropdownvalue == filterList[1] &&
          markersList[i].get("station_occupancy")[0] > 0.9)
        initMarker(markersList[i], markersList[i].id);
      else if (dropdownvalue == filterList[2] &&
          markersList[i].get("station_occupancy")[0] <= 0.1)
        initMarker(markersList[i], markersList[i].id);
    }
  }

  /*
  * Initialized the individual markers and add them to the map of markers
  * */
  void initMarker(stationData, stationID) {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    var bikeStand = stationData.get("available_bike_stands").toString();
    var freeBikes = stationData.get("available_bikes")[0].toString();
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(stationData.get("latitude").toString()),
          double.parse(stationData.get("longitude").toString())),
      infoWindow: InfoWindow(
          title: stationData.get("station_name"),
          snippet: "Stands: $bikeStand | Bikes: $freeBikes"),
    );
    markers[markerId] = marker;
  }

  /*
  * This function replaces the setState in initMarker() which was causing an error because
  * it was being called before the StreamBuilder was done building
  * */
  Map<MarkerId, Marker> getMarkers() {
    return markers;
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
    return Scaffold(
      appBar: appBar,
      drawer: SideMenu(),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('DublinBikes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            initAllMarkers(snapshot.data!.docs);
            return Column(
              children: <Widget>[
                new Container(
                    height: (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.10,
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
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: DropdownButton(
                                value: dropdownvalue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: filterList.map((String items) {
                                  return DropdownMenuItem(
                                      value: items, child: Text(items));
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                    initAllMarkers(snapshot.data!.docs);
                                  });
                                },
                              ),
                            ),
                          ],
                        ))),
                new Container(
                    height: (MediaQuery.of(context).size.height - appBar.preferredSize.height) * 0.90,
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
            return Text("Error pa thambi!");
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
