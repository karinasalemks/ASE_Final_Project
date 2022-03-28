import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventLocationMap extends StatefulWidget {
  final snapshot;

  const EventLocationMap({Key? key, required this.snapshot}) : super(key: key);

  @override
  _EventLocationMapState createState() => _EventLocationMapState();
}

class _EventLocationMapState extends State<EventLocationMap> {
  late DateTime _selectedDate;
  TextEditingController _textEditingController = TextEditingController();

  late BitmapDescriptor customIcon;
  late BitmapDescriptor customIcon_orange;
  late BitmapDescriptor customIcon_red;
  late BitmapDescriptor customIcon_green;
  bool mapToggle = false;
  var currentLocation;
  var filterList = [
    'All Upcoming Events',
    'Filter By Date',
    'Next 1 Week',
    'Next 2 Weeks',
    'Next 3 Weeks'
  ]; //station occupancy filter list
  String dropdownvalue =
      'All Upcoming Events'; // the default value for the station occupancy filter

  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  AppBar appBar = AppBar(
    title: Text("Dublin Events Map"),
  );

  //is not used.
  getMarkerData() async {
    /*FirebaseFirestore.instance
        .collection('DublinBikes')
        .get()
        .then((myMarkers) {
      if (myMarkers.docs.isNotEmpty) {
        for (int i = 0; i < myMarkers.docs.length; i++) {
          initMarker(myMarkers.docs[i], myMarkers.docs[i].id, customIcon);
        }
      }
    });*/
    customIcon_red = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker_red.png');
    if (widget.snapshot.docs.length > 0) {
      var eventList = widget.snapshot.docs;
      List locationName = [];
      List events = [];
      List location = [];
      for (int i = 0; i < eventList.length; i++) {
        var eventName = eventList[i].get("name");
        var location_name = eventList[i].get("location_name");
        var date = eventList[i].get("date");
        var dateTime = DateTime.parse(date);
        var dateFormat = DateFormat("yy-MM-dd");
        var timeFormat = DateFormat("HH:mm:ss");
        var formattedDate = dateFormat.format(dateTime);
        var formattedTime = timeFormat.format(dateTime);
        /*print("dateTime:" + date);
        print("date:"+ dateFormat.format(dateTime));
        print("time:"+ timeFormat.format(dateTime));*/
        if (locationName.contains(location_name)) {
          var index = locationName.indexOf(location_name);
          events[index] += "Date: $formattedDate\nTime: $formattedTime\nEvent: $eventName<br /><br />";
        } else {
          locationName.add(location_name);
          events.add("Date: $formattedDate\nTime: $formattedTime\nEvent: $eventName<br /><br />");
          location.add([eventList[i].get("longitude"), eventList[i].get("latitude")]);
        }
      }
      for (int i = 0; i < locationName.length; i++) {
        addMarkerForEvents(locationName[i], location[i], events[i]);
      }
    }
  }

  /*
  * This function initializes all the markers from the data formatted
  * for each event location
  * */
  void addMarkerForEvents(var location, var lat_long, var eventList) {
    final MarkerId markerId = MarkerId(location);
    final Marker marker = Marker(
      markerId: markerId,
      icon: customIcon_red,
      position: LatLng(double.parse(lat_long[0]), double.parse(lat_long[1])),
      infoWindow: InfoWindow(
          title: location,
          snippet:
          eventList),
    );
    markers[markerId] = marker;
  }

  /*
  * This function initializes all the markers from the data received from firebase
  * it is also used in filtering based on station occupancy
  * */
  void initAllMarkers(var markersList) {
    markers.clear();
    for (int i = 0; i < markersList.length; i++) {
      if (dropdownvalue == filterList[0]) {
        if (markersList[i].get("station_occupancy")[0] >= 0.75)
          initMarker(markersList[i], markersList[i].id, customIcon);
        else if (markersList[i].get("station_occupancy")[0] >= 0.50)
          initMarker(markersList[i], markersList[i].id, customIcon_green);
        else if (markersList[i].get("station_occupancy")[0] <= 0.25)
          initMarker(markersList[i], markersList[i].id, customIcon_red);
        else
          initMarker(markersList[i], markersList[i].id, customIcon_orange);
      } else if (dropdownvalue == filterList[1] &&
          markersList[i].get("station_occupancy")[0] >= 0.75)
        initMarker(markersList[i], markersList[i].id, customIcon);
      else if (dropdownvalue == filterList[2] &&
          markersList[i].get("station_occupancy")[0] >= 0.50 &&
          markersList[i].get("station_occupancy")[0] < 0.75)
        initMarker(markersList[i], markersList[i].id, customIcon_green);
      else if (dropdownvalue == filterList[3] &&
          markersList[i].get("station_occupancy")[0] <= 0.50 &&
          markersList[i].get("station_occupancy")[0] > 0.25)
        initMarker(markersList[i], markersList[i].id, customIcon_orange);
      else if (dropdownvalue == filterList[4] &&
          markersList[i].get("station_occupancy")[0] <= 0.25)
        initMarker(markersList[i], markersList[i].id, customIcon_red);
    }
  }

  /*
  * Initialized the individual markers and add them to the map of markers
  * */
  void initMarker(stationData, stationID, inputIcon) {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    var bikeStand = stationData.get("available_bikeStands")[0];
    var freeBikes = stationData.get("available_bikes")[0];
    var totalBikes = bikeStand + freeBikes;
    bikeStand = bikeStand.toString();
    freeBikes = freeBikes.toString();
    totalBikes = totalBikes.toString();
    final Marker marker = Marker(
      markerId: markerId,
      icon: inputIcon,
      position: LatLng(double.parse(stationData.get("latitude").toString()),
          double.parse(stationData.get("longitude").toString())),
      infoWindow: InfoWindow(
          title: stationData.get("station_name"),
          snippet:
          "Total Stands:$totalBikes\nAvailable Stands: $bikeStand\nAvailable Bikes: $freeBikes"),
    );
    markers[markerId] = marker;
  }

  /*
  * Initialized the individual markers and add them to the map of markers
  * */
  Future<void> initEventMarker(stationData, stationID, inputIcon) async {
    var markerIdVal = stationID;
    final MarkerId markerId = MarkerId(markerIdVal);
    var bikeStand = stationData.get("available_bikeStands")[0];
    var freeBikes = stationData.get("available_bikes")[0];
    var totalBikes = bikeStand + freeBikes;
    bikeStand = bikeStand.toString();
    freeBikes = freeBikes.toString();
    totalBikes = totalBikes.toString();
    final Marker marker = Marker(
      markerId: markerId,
      icon: inputIcon,
      position: LatLng(double.parse(stationData.get("latitude").toString()),
          double.parse(stationData.get("longitude").toString())),
      infoWindow: InfoWindow(
          title: stationData.get("station_name"),
          snippet:
          "Total Stands:$totalBikes\nAvailable Stands: $bikeStand\nAvailable Bikes: $freeBikes"),
    );
    markers[markerId] = marker;
  }

  /*
  * This function replaces the setState in initMarker() which was causing an error because
  * it was being called before the StreamBuilder was done building
  * */
  Map<MarkerId, Marker> getMarkers() {
    print("return marker_length" + (markers.length).toString());
    return markers;
  }

  @override
  void initState() {
    //getMapIcon();
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

  getMapIcon() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker.png');
    customIcon_orange = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker_orange.png');
    customIcon_red = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker_red.png');
    customIcon_green = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bike_station_marker_green.png');
    if (widget.snapshot.docs.length > 0) {
      initAllMarkers(widget.snapshot.docs);
    }
  }

  eventMapHeaderContainer(heightOfFilter, snapshot) {
    _selectDate(BuildContext context) async {
      /*DateTime? newSelectedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2040),
          builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  surface: Colors.blueGrey,
                  onSurface: Colors.yellow,
                ),
                dialogBackgroundColor: Colors.blue[500],
              ),
              child: child,
            );
          });

      if (newSelectedDate != null) {
        _selectedDate = newSelectedDate;
        _textEditingController
          ..text = DateFormat.yMMMd().format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _textEditingController.text.length,
              affinity: TextAffinity.upstream));
      }*/
    }
    return new Container(
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
                      child: Text('Event Date Filter',
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
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                        //initAllMarkers(snapshot.docs);
                        // initAllMarkers(snapshot.data!.docs);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _textEditingController,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),

                  ),
                ),
              ],
            )));


  }



  eventsMapContainer(heightOfFilter, snapshot) {
    return new Container(
        height: (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            heightOfFilter) *
            0.90,
        key: Key("dublin-events-map"),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(53.344007, -6.266802),
            zoom: 15.0,
          ),
          markers: Set<Marker>.of(getMarkers().values),
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
                  // DublinBikesUsageChart(snapshot: snapshot),
                  eventMapHeaderContainer(heightOfFilter, widget.snapshot),
                  eventsMapContainer(heightOfFilter, widget.snapshot)
                ],
              ))),
    );
  }
}
