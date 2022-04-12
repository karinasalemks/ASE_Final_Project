import 'package:flutter/material.dart';
import 'package:ase_group5_scm/pages/DublinBikes/DublinBikes.dart';
import 'package:ase_group5_scm/pages/DublinBuses/DublinBus.dart';
import 'package:ase_group5_scm/pages/Luas/Luas.dart';
import 'package:ase_group5_scm/pages/overview/overview.dart';
import 'package:ase_group5_scm/routing/routes.dart';
import 'package:ase_group5_scm/pages/DublinEvents/DublinEvents.dart';

Route<dynamic> generateRoute(RouteSettings settings){
  var clientsPageRoute2 = overviewPageRoute;
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case dublinBikesPageRoute:
      return _getPageRoute(DublinBikes());
    case dublinBusesPageRoute:
      return _getPageRoute(DublinBus());
    case luasPageRoute:
      return _getPageRoute(Luas());
    case eventsPageRoute:
      return _getPageRoute(DublinEvents());
    default:
      return _getPageRoute(OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child){
  return MaterialPageRoute(builder: (context) => child);
}