import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/DublinBikes/dublin_bikes_map.dart';
import 'package:ase_group5_scm/DublinBikes/dublin_bikes_usage_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomStreamBuilder extends StatelessWidget {
  final String collectionName;
  final String viewName;

  const CustomStreamBuilder(
      {Key? key, required this.collectionName, required this.viewName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Object?>>? getCollectionStream(collectionName) {
      Stream<QuerySnapshot<Object?>>? stream = null;
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
      }
      return stream;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: getCollectionStream(collectionName),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
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
