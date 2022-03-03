import 'package:flutter/material.dart';
import 'package:ase_group5_scm/Components/SideMenu.dart';
import 'dublin_bikes_map.dart';

List _bikeScreenList = [
  BikeStationMap(),
  BikeStationMap(),
];

//replace the below list values with corresponding nested screen widgets
List _busesScreenList = [
  BikeStationMap(),
  Text(' bus placeholder Text'),
  Text(' bus placeholder Text')
];
List _luasScreenList = [
  BikeStationMap(),
  Text(' luas Placeholder Text'),
  Text(' luas placeholder Text')
];
List _eventScreenList = [
  BikeStationMap(),
  Text(' event Placeholder Text'),
  Text(' event placeholder Text')
];


/*
* IntermediateInterface is a StatefulWidget class that provides the functionality of bottom navigation bar
* to navigate among different screens for a single indicator entity.
* */
class IntermediateInterface extends StatefulWidget {
  const IntermediateInterface({Key? key}) : super(key: key);

  @override
  _IntermediateInterfaceState createState() => _IntermediateInterfaceState();
}

class _IntermediateInterfaceState extends State<IntermediateInterface> {
  int _selectedIndex = 0;

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
    String? selectedSideMenu =
        ModalRoute.of(context)?.settings.arguments as String?;
    selectedSideMenu = selectedSideMenu == null || selectedSideMenu.isEmpty?"Dublin Bikes":selectedSideMenu;
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
