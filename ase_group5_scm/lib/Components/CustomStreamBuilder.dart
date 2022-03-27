import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/pages/DublinBikes/dublin_bikes_map.dart';
import 'package:ase_group5_scm/pages/DublinBikes/dublin_bikes_usage_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilder extends StatelessWidget {
  final String collectionName;
  final String viewName;

/*   CustomStreamBuilder takes a Firebase collection name and a 'view' name,
   and uses them to return a Flutter Container to display the required info.*/

  const CustomStreamBuilder(
      {Key? key, required this.collectionName, required this.viewName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>>? getCollectionStream(collectionName) {
      Stream<QuerySnapshot<Object?>>? stream = null;

      // Add a switch case for your collection name here.

      switch (collectionName) {
        case AppConstants.DUBLIN_BIKES_COLLECTION:
          stream = FirebaseFirestore.instance
              .collection(AppConstants.DUBLIN_BIKES_COLLECTION)
              .snapshots();
          break;
        case AppConstants.BIKES_SWAPS_COLLECTION:
          stream = FirebaseFirestore.instance
              .collection(AppConstants.BIKES_SWAPS_COLLECTION)
              .snapshots();
          break;
        case AppConstants.DUBLIN_BUS_COLLECTION:
          stream = FirebaseFirestore.instance
              .collection(AppConstants.DUBLIN_BUS_COLLECTION)
              .snapshots();
          break;
        case AppConstants.DUBLIN_LUAS_COLLECTION:
          stream = FirebaseFirestore.instance
              .collection(AppConstants.DUBLIN_LUAS_COLLECTION)
              .snapshots();
          break;
        case AppConstants.DUBLIN_EVENTS_COLLECTION:
          stream = FirebaseFirestore.instance
              .collection(AppConstants.DUBLIN_EVENTS_COLLECTION)
              .snapshots();
          break;
      }
      return stream;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: getCollectionStream(collectionName),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {

          // Based on the viewName, this switch statement will return the
          // required Container. Once you've written the Widget, add it here.
          // Make sure you add the view name to the AppConstants.dart file

          switch (viewName) {
            case AppConstants.DUBLIN_BIKES_MAP_VIEW:
              return BikeStationMap(snapshot: snapshot.data);
            case AppConstants.DUBLIN_BIKES_CHARTS_VIEW:
              return DublinBikesUsageChart(
                snapshot: snapshot.data,
              );
            case AppConstants.DUBLIN_BIKES_SWAPS_VIEW:
              //TODO:add swaps here
              return Text("swaps");
            case AppConstants.DUBLIN_BUS_MAP_VIEW:
            //TODO:add DublinBus Map here
              return Text("Dublin Bus Map");
            case AppConstants.DUBLIN_BUS_CO2_VIEW:
            //TODO:add DublinBus Co2 here
              return Text("DublinBus Co2");
            case AppConstants.DUBLIN_BUS_REROUTE_VIEW:
            //TODO:add DublinBus Rerouting here
              return Text("DublinBus Rerouting");
            case AppConstants.DUBLIN_LUAS_MAP_VIEW:
            //TODO:add Luas Map here
              return Text("Luas Map");
            case AppConstants.DUBLIN_LUAS_ELEC_VIEW:
            //TODO:add Luas electricity here
              return Text("Luas Electricity");
            case AppConstants.DUBLIN_EVENTS_MAP_VIEW:
            //TODO:add Dublin Events Map here
              return Text("Dublin Events Map");
            case AppConstants.DUBLIN_EVENTS_BUS_SUG_VIEW:
            //TODO:add Events Bus Suggestions here
              return Text("Events Bus Suggestions");
            case AppConstants.DUBLIN_EVENTS_FORECAST_VIEW:
            //TODO:add Dublin Forecast here
              return Text("Dublin Forecast");
            default:
              return Text("error in stream builder");
          }
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
    );
  }
}
