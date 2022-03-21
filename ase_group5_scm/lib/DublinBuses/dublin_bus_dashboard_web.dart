import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:ase_group5_scm/Components/Utils.dart';
import 'package:ase_group5_scm/DublinBikes/dublin_bikes_map.dart';
import 'package:ase_group5_scm/DublinBikes/dublin_bikes_usage_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DublinBusDashboardWeb extends StatefulWidget {
  const DublinBusDashboardWeb({Key? key}) : super(key: key);

  @override
  _DublinBusDashboardWebState createState() =>
      _DublinBusDashboardWebState();
}

class _DublinBusDashboardWebState extends State<DublinBusDashboardWeb> {
  StreamBuilder<Object?> combinedStreams() {
    Stream<QuerySnapshot> busStream = FirebaseFirestore.instance
        .collection(AppConstants.DUBLIN_LUAS_COLLECTION)
        .snapshots();
    //If needed, add other streams here
    return StreamBuilder(
        stream: CombineLatestStream.list([
          busStream
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
                        //Return the required Container (same as in CustomStreamBuilder) here
                        //child: BikeStationMap(snapshot: snapshot),
                        child: Text("1st Widget"),
                        flex: 2,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("2nd Widget"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Utils.getAppBarTitle(context))),
        drawer: SideMenu(),
        body: combinedStreams());
  }
}
