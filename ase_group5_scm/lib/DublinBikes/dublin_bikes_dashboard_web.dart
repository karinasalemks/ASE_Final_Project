import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/Components/CustomStreamBuilder.dart';
import 'package:ase_group5_scm/Components/CustomStreamBuilder.dart';
import 'package:ase_group5_scm/Components/CustomStreamBuilder.dart';
import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:ase_group5_scm/Components/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DublinBikesDashboardWeb extends StatefulWidget {
  const DublinBikesDashboardWeb({Key? key}) : super(key: key);

  @override
  _DublinBikesDashboardWebState createState() => _DublinBikesDashboardWebState();
}

class _DublinBikesDashboardWebState extends State<DublinBikesDashboardWeb> {

  @override
  Widget build(BuildContext context) {
    print(this.mounted == true);
    return Scaffold(
        appBar: AppBar(title: Text(Utils.getAppBarTitle(context))),
        drawer: SideMenu(),
        body: IntrinsicHeight(
            child: Row(
                mainAxisSize: MainAxisSize.max, // match parent
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Expanded(
                child: CustomStreamBuilder(
                  collectionName: AppConstants.DUBLIN_BIKES_COLLECTION,
                  viewName: AppConstants.DUBLIN_BIKES_MAP_VIEW,
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomStreamBuilder(
                        collectionName: AppConstants.DUBLIN_BIKES_COLLECTION,
                        viewName: AppConstants.DUBLIN_BIKES_CHARTS_VIEW,
                      ),
                      CustomStreamBuilder(
                        collectionName: AppConstants.DUBLIN_BIKES_COLLECTION,
                        viewName: AppConstants.DUBLIN_BIKES_CHARTS_VIEW,
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),
            ])));
  }
}
