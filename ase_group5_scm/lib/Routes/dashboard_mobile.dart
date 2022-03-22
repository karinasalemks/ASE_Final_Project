import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:ase_group5_scm/Components/CustomIcons.dart';
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
  CustomStreamBuilder(
      collectionName: AppConstants.BIKES_SWAPS_COLLECTION,
      viewName: AppConstants.DUBLIN_BIKES_SWAPS_VIEW),
];

//replace the below list values with corresponding nested screen widgets
List _busesScreenList = [
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_BUS_COLLECTION,
      viewName: AppConstants.DUBLIN_BUS_MAP_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_BUS_COLLECTION,
      viewName: AppConstants.DUBLIN_BUS_CO2_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_BUS_COLLECTION,
      viewName: AppConstants.DUBLIN_BUS_REROUTE_VIEW),
];

List _luasScreenList = [
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_LUAS_COLLECTION,
      viewName: AppConstants.DUBLIN_LUAS_MAP_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_LUAS_COLLECTION,
      viewName: AppConstants.DUBLIN_LUAS_ELEC_VIEW),
];

List _eventScreenList = [
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_EVENTS_COLLECTION,
      viewName: AppConstants.DUBLIN_EVENTS_MAP_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_EVENTS_COLLECTION,
      viewName: AppConstants.DUBLIN_EVENTS_BUS_SUG_VIEW),
  CustomStreamBuilder(
      collectionName: AppConstants.DUBLIN_EVENTS_COLLECTION,
      viewName: AppConstants.DUBLIN_EVENTS_FORECAST_VIEW),
];

/*
* IntermediateInterface is a StatefulWidget class that provides the functionality of bottom navigation bar
* to navigate among different screens for a single indicator entity.
* */
class DashboardMobile extends StatefulWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  _DashboardMobileState createState() =>
      _DashboardMobileState();
}

class _DashboardMobileState
    extends State<DashboardMobile> {
  int _selectedIndex = 0;
  String? selectedSideMenu;

  //map that holds all the individual screen lists in corresponding keys
  var _children = {
    AppConstants.DUBLIN_BIKES: _bikeScreenList,
    AppConstants.DUBLIN_BUSES: _busesScreenList,
    AppConstants.DUBLIN_LUAS: _luasScreenList,
    AppConstants.DUBLIN_EVENTS: _eventScreenList
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
      case AppConstants.DUBLIN_BIKES:
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
            BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'swaps',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        );
        return barToReturn;
      case AppConstants.DUBLIN_BUSES:
        barToReturn = BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              // icon: Icon(IconData(0xf04d0, fontFamily: 'MaterialIcons')),
              icon: Icon(CustomIcons.co2),
              label: 'co2',
            ),
            BottomNavigationBarItem(
            icon: Icon(IconData(0xe624, fontFamily: 'MaterialIcons')),
            label: 'Bus rerouting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        );
        return barToReturn;
        case AppConstants.DUBLIN_LUAS:
          barToReturn = BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.tram),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bolt),
                label: 'electricty',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          );
          return barToReturn;
        case AppConstants.DUBLIN_EVENTS:
          barToReturn = BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(IconData(0xf06bb, fontFamily: 'MaterialIcons')),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus),
                label: 'bus frequency',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'forecast',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          );
          return barToReturn;
      default:
        barToReturn = BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(IconData(0xf06bb, fontFamily: 'MaterialIcons')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: 'bus frequency',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'forecast',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        );
        return barToReturn;
    }
  }
}
