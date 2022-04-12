import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dublin_events_map.dart';
import 'widgets/events_table.dart';

class EventsDashboardWeb extends StatefulWidget {
  const EventsDashboardWeb({Key? key}) : super(key: key);

  @override
  _EventsDashboardWebState createState() =>
      _EventsDashboardWebState();
}

class _EventsDashboardWebState extends State<EventsDashboardWeb> {
  late GoogleMapController mapController;

  StreamBuilder<Object?> combinedStreams() {
    Stream<QuerySnapshot> eventsStream = FirebaseFirestore.instance
        .collection(AppConstants.DUBLIN_EVENTS_COLLECTION)
        .snapshots();
    //If needed, add other streams here
    return StreamBuilder(
        stream: CombineLatestStream.list([
          eventsStream
        ]),
        builder: (context, combinedSnapshot) {
          if (combinedSnapshot.hasData) {
            var snapshotList = combinedSnapshot.data as List<QuerySnapshot>;
            var snapshot = snapshotList[0];
            return IntrinsicHeight(
                child: Row(
                    mainAxisSize: MainAxisSize.max, // match parent
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: EventLocationMap(snapshot: snapshot),
                        flex: 2,
                        //flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                              child: EventsTable(snapshot: snapshot)),
                              Text("3rd Widget")
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ]));
          } else {
            return Center(
                child: Transform.scale(
                  scale: 1,
                  child: CircularProgressIndicator(),
                ));
          }
        });
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Utils.getAppBarTitle(context))),
        drawer: SideMenu(),
        body: combinedStreams());
  }*/

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          child: combinedStreams()),
    );
  }
}