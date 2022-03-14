import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/Components/CustomStreamBuilder.dart';
import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'package:ase_group5_scm/Components/Utils.dart';
import 'package:flutter/material.dart';

List _bikeScreenList = [
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_BIKES_COLLECTION,
      viewName: AppConstants.DUBLIN_BIKES_MAP_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_BIKES_COLLECTION,
      viewName: AppConstants.DUBLIN_BIKES_CHARTS_VIEW),
];

//replace the below list values with corresponding nested screen widgets
List _busesScreenList = [
  Text(' bus placeholder Text'),
  Text(' bus placeholder Text')
];
List _luasScreenList = [
  Text(' luas Placeholder Text'),
  Text(' luas placeholder Text')
];
List _eventScreenList = [
  Text(' event Placeholder Text'),
  Text(' event placeholder Text')
];

/*
* IntermediateInterface is a StatefulWidget class that provides the functionality of bottom navigation bar
* to navigate among different screens for a single indicator entity.
* */
class DublinBikesDashboardMobile extends StatefulWidget {
  const DublinBikesDashboardMobile({Key? key}) : super(key: key);

  @override
  _DublinBikesDashboardMobileState createState() =>
      _DublinBikesDashboardMobileState();
}

class _DublinBikesDashboardMobileState
    extends State<DublinBikesDashboardMobile> {
  int _selectedIndex = 0;
  String? selectedSideMenu;

  //map that holds all the individual screen lists in corresponding keys
  var _children = {
    "Dublin Bikes": _bikeScreenList,
    "Buses": _busesScreenList,
    "Luas": _luasScreenList,
    "Events": _eventScreenList
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedSideMenu = Utils.getAppBarTitle(context);
    return Scaffold(
        appBar: AppBar(title: Text(selectedSideMenu)),
        drawer: SideMenu(),
        body: Center(child: _children[selectedSideMenu]![_selectedIndex]),
        bottomNavigationBar: getNavigationBarWidget(selectedSideMenu));
  }

  /*
  * getNavigationBarWidget method returns the bottom navigation bar for corresponding indicator
  *
  * @param String indicator (the string value for corresponding indicator)
  * @return BottomNavigationBar object
  * */
  BottomNavigationBar getNavigationBarWidget(String indicator) {
    BottomNavigationBar barToReturn;
    switch (indicator) {
      //add future indicators as new case here
      default:
        barToReturn = BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.pedal_bike),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Bar_chart_placeHolder',
            ),
            // BottomNavigationBarItem(
            //icon: Icon(Icons.map),
            // label: 'Heat Map placeHolder',
            //),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        );
        return barToReturn;
    }
  }
}
