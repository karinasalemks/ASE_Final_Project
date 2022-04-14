import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:ase_group5_scm/pages/overview/widgets/info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

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
  late List<dynamic> dataset_redLine;
  late List<dynamic> dataset_greenLine;
  late Map<dynamic, dynamic> dataset_trams;
  late GoogleMapController mapController;
  bool flag = false;
  List<bool> isSelected = [true, false];
  bool toggleState = true;
  late var elecluas_data_red = null;
  late var elecluas_data_green = null;
  late var active_data_red = null;
  late var active_data_green = null;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers_dummy = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAGUwl_spXiMnoxkDmPpAj0sVsfccchDjY";
  var _polylineCount = 0;

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
    dataset_greenLine = markersList[0]['green_line'];
    dataset_redLine = markersList[0]['red_line'];
    dataset_trams = markersList[1]['data']['luas_data'];
    print(dataset_redLine.length);
    elecluas_data_red =
        markersList[1]['data']['red_line']['electricity_consumption_estimate'];
    elecluas_data_green = markersList[1]['data']['green_line']
        ['electricity_consumption_estimate'];

    active_data_green = markersList[1]['data']['green_line']['num_active_luas'];
    active_data_red = markersList[1]['data']['red_line']['num_active_luas'];
    dataset.forEach((k, v) => initMarker(
        v['name'],
        v['Latitude'],
        v['Longitude'],
        k,
        dataset_trams[k]['inboundTramsCount'],
        dataset_trams[k]['outboundTramsCount'],
        dataset_trams[k]['line'],
        low));
    print("here before polyline");
    getpolylinefromlist(dataset_redLine, Colors.red);
    getpolylinefromlist(dataset_greenLine, Colors.green);
    getpolylinefromname("TAL", "BEL", Colors.red);
    getpolylinefromname("TRY", "OUP", Colors.green);
  }

  void getpolylinefromlist(var stationslist, MaterialColor varcolor) {
    double origin_lat = dataset[stationslist[0]]['Latitude'];
    double origin_longi = dataset[stationslist[0]]['Longitude'];
    double dest_lat =
        dataset[stationslist[stationslist.length - 1]]['Latitude'];
    double dest_longi =
        dataset[stationslist[stationslist.length - 1]]['Longitude'];
    List<PolylineWayPoint> wayPoint = [];
    _getPolyline(
        origin_lat, origin_longi, dest_lat, dest_longi, wayPoint, varcolor);
  }

  void getpolylinefromname(var src, var dest, MaterialColor varcolor) {
    double origin_lat = dataset[src]['Latitude'];
    double origin_longi = dataset[src]['Longitude'];

    double dest_lat = dataset[dest]['Latitude'];
    double dest_longi = dataset[dest]['Longitude'];

    List<PolylineWayPoint> wayPoint = [];
    _getPolyline(
        origin_lat, origin_longi, dest_lat, dest_longi, wayPoint, varcolor);
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
      infoWindow: InfoWindow(
          title: station_name,
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

  getMapIcon() async {
    low = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(36, 36)),
        'assets/image/luas_station_1.png');
  }

  _addPolyLine(MaterialColor colorreceived) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Sending Message"),
          ));
        },
        polylineId: id,
        color: colorreceived,
        points: polylineCoordinates,
        width: 4);
    polylines[id] = polyline;
    setState(() {
      // polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _getPolyline(var orig_lati, var orig_longi, var dest_lati, var dest_longi,
      var wayPointList, MaterialColor varcolor) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(orig_lati, orig_longi),
        PointLatLng(dest_lati, dest_longi),
        travelMode: TravelMode.transit);

    polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine(varcolor);
  }

  bikeMapHeaderContainer(heightOfFilter) {
    double _width = MediaQuery.of(context).size.width;
    return (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InfoCard(
                    title: "Red Line \n Active Luas $active_data_red \n"
                        "Electricity Consumption :  $elecluas_data_red",
                    value: "",
                    onTap: () {},
                    topColor: Colors.red,
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Green Line \n Active Luas $active_data_green \n"
                        "Electricity Consumption :  $elecluas_data_green",
                    value: "",
                    topColor: Colors.green,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InfoCard(
                    title: "Red Line  ",
                    value: "Active Luas : $active_data_red \n"
                        "Electricity Consmption :$elecluas_data_red ",
                    onTap: () {},
                    topColor: Colors.red,
                  ),
                  SizedBox(
                    width: _width / 64,
                  ),
                  InfoCard(
                    title: "Green Line  ",
                    value: "Active Luas : $active_data_green \n"
                        "Electricity Consmption :$elecluas_data_green ",
                    topColor: Colors.green,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
  }

  LuasMapContainer(heightOfFilter) {
    // _getSize();
    return new Container(
        padding: const EdgeInsets.all(8.0),
        height: (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android)
            ? (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                heightOfFilter -
                150)
            : (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                heightOfFilter -
                100),
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
          polylines: Set<Polyline>.of(polylines.values),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var heightOfFilter =
        (MediaQuery.of(context).size.height - appBar.preferredSize.height) *
            0.10;
    //Todo: Refine the code here to stop calling setState method before build.

    return (this.elecluas_data_green != null && this.elecluas_data_red != null)
        ? Container(
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height - heightOfFilter,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        bikeMapHeaderContainer(heightOfFilter),
                        LuasMapContainer(heightOfFilter),
                      ],
                    ))),
          )
        : Center(
            child: Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
  }
}
