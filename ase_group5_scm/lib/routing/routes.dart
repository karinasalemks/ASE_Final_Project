const rootRoute = "/";

const overviewPageDisplayName = "Overview";
const overviewPageRoute = "/overview";

const dublinBikesDisplayName = "Dublin Bikes";
const dublinBikesPageRoute = "/dublinBikes";

const dublinBusesDisplayName = "Dublin Buses";
const dublinBusesPageRoute = "/dublinBuses";

const luasDisplayName = "Luas";
const luasPageRoute = "/luas";

const eventsDisplayName = "Events";
const eventsPageRoute = "/events";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}



List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(dublinBikesDisplayName, dublinBikesPageRoute),
  MenuItem(dublinBusesDisplayName, dublinBusesPageRoute),
  MenuItem(luasDisplayName, luasPageRoute),
  MenuItem(eventsDisplayName, eventsPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
