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
  late BitmapDescriptor customIcon_concert;
  late BitmapDescriptor customIcon_sports;
  late BitmapDescriptor customIcon_theater;
  late BitmapDescriptor customIcon_bus_stop;
  bool mapToggle = false;
  var currentLocation;
  static final filterList = [
    'All Upcoming Events',
    'Next 1 Week',
    'Next 2 Weeks',
    'Next 3 Weeks'
  ];
  static final busStopFilterList = [
    'No Bus Stops',
    'Aviva Stadium',
    'National Stadium',
    'Gaiety Theatre',
    'Bord Gais Energy Theatre',
    '3Arena'
  ];//station occupancy filter list
  String dropdownvalue =
      'All Upcoming Events'; // the default value for the station occupancy filter
  String stopDdropdownvalue =
      'No Bus Stops';
  late GoogleMapController mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> busStopMarkers = <MarkerId, Marker>{};

  AppBar appBar = AppBar(
    title: Text("Dublin Events Map"),
  );

  //to get the marker data for each event location
  getMarkerData() async {
    var noOfDays = 30;
    if (dropdownvalue == filterList[0]) {
      noOfDays = 30;
    } else if (dropdownvalue == filterList[1]) {
      noOfDays = 7;
    } else if (dropdownvalue == filterList[2]) {
      noOfDays = 14;
    } else if (dropdownvalue == filterList[3]) {
      noOfDays = 21;
    }
    customIcon_concert = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/events_concert.png');
    customIcon_sports = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/events_sports.png');
    customIcon_theater = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/events_theater.png');
    customIcon_bus_stop = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/bus_stop.png');
    if (widget.snapshot.docs.length > 0) {
      var eventList = widget.snapshot.docs;
      for (int i = 0; i < eventList.length; i++) {
        var listOfEvents = "";
        var location_name = eventList[i].get("location_name");
        var latitude = eventList[i].get("latitude");
        var longitude = eventList[i].get("longitude");
        var events = eventList[i].get("events");
        var event_near_by_stops = eventList[i].get("nearest_bus_stops");
        if (location_name == stopDdropdownvalue) {
          event_near_by_stops.forEach((key, value) {
            addMarkerForBusStops(key, value[0], value[1], key);
          });
        }
        var myMap = events.map((key, value) => MapEntry(key, value.toString()));
        for(String key in myMap.keys) {
          var eventName = myMap[key];
          var date = key;
          var dateTime = DateTime.parse(date);
          var currentDate = DateTime.now();
          if (dateTime.difference(currentDate).inDays >= 0 && dateTime.difference(currentDate).inDays <= noOfDays) {
            var dateFormat = DateFormat("yy-MM-dd");
            var timeFormat = DateFormat("HH:mm:ss");
            var formattedDate = dateFormat.format(dateTime);
            var formattedTime = timeFormat.format(dateTime);
            listOfEvents += "Date: $formattedDate\nTime: $formattedTime\nEvent: $eventName<br /><br />";
          }
        }
        addMarkerForEvents(location_name, latitude, longitude, listOfEvents);
      }
    }
  }

  /*
  * This function initializes all the markers from the data formatted
  * for each event location
  * */
  void addMarkerForBusStops(var location, var lat, var long, var info) {
    final MarkerId markerId = MarkerId(location);
    BitmapDescriptor mapIcon = customIcon_bus_stop;
    final Marker marker = Marker(
      markerId: markerId,
      icon: mapIcon,
      position: LatLng(lat, long),
      infoWindow: InfoWindow(title: location),
    );
    busStopMarkers[markerId] = marker;
  }

  /*
  * This function initializes all the markers from the data formatted
  * for each event location
  * */
  void addMarkerForEvents(var location, var lat, var long, var eventList) {
    final MarkerId markerId = MarkerId(location);
    BitmapDescriptor mapIcon = customIcon_concert;
    switch(location) {
      case "Aviva Stadium":
      case "National Stadium":
      mapIcon = customIcon_sports;
      break;
      case "Gaiety Theatre":
      case "Bord Gais Energy Theatre":
        mapIcon = customIcon_theater;
        break;
      case "3Arena":
      mapIcon = customIcon_concert;
      break;
    }
    final Marker marker = Marker(
      markerId: markerId,
      icon: mapIcon,
      position: LatLng(double.parse(lat), double.parse(long)),
      infoWindow: InfoWindow(title: location, snippet: eventList),
    );
    markers[markerId] = marker;
  }

  /*
  * This function replaces the setState in initMarker() which was causing an error because
  * it was being called before the StreamBuilder was done building
  * */
  Map<MarkerId, Marker> getMarkers() {
    Map<MarkerId, Marker> finalMarkers = {};
    finalMarkers.addAll(busStopMarkers);
    finalMarkers.addAll(markers);
    return finalMarkers;
  }

  @override
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

  eventMapHeaderContainer(heightOfFilter, snapshot) {

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
                      child: Text('Event Date',
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
                  width: 10,
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
                        getMarkerData();
                      });
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text('Bus Stop',
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
                  width: 10,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: DropdownButton(
                    value: stopDdropdownvalue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: busStopFilterList.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        busStopMarkers = {};
                        stopDdropdownvalue = newValue!;
                        getMarkerData();
                      });
                    },
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
            target: LatLng(53.331066, -6.250250),
            zoom: 13.0,
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
                  eventMapHeaderContainer(heightOfFilter, widget.snapshot),
                  eventsMapContainer(heightOfFilter, widget.snapshot)
                ],
              ))),
    );
  }
}