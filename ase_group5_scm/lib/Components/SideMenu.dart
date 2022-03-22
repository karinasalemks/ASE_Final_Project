import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var sideMenuIndex = 0;

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var color = const Color(0xffE6E6E6);
  String? auth = FirebaseAuth.instance.currentUser == null
      ? "guest"
      : FirebaseAuth.instance.currentUser?.email;

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      sideMenuIndex = 0;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://source.unsplash.com/50x50/?portrait',
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      auth!,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )),
          ListTile(
            title: Text('Dublin Bikes',
                style: TextStyle(
                    color: sideMenuIndex == 0 ? Colors.blue : Colors.black)),
            tileColor: sideMenuIndex == 0 ? color : null,
            onTap: () {
              setState(() {
                sideMenuIndex = 0;
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context)
                  .pushNamed("/DublinBikesDashboard", arguments: "Dublin Bikes");
            },
          ),
          ListTile(
            title: Text('Dublin Bus',
                style: TextStyle(
                    color: sideMenuIndex == 1 ? Colors.blue : Colors.black)),
            tileColor: sideMenuIndex == 1 ? color : null,
            onTap: () {
              setState(() {
                sideMenuIndex = 1;
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context)
                  .pushNamed("/DublinBusDashboard", arguments: "Buses");
            },
          ),
          ListTile(
            title: Text('Luas',
                style: TextStyle(
                    color: sideMenuIndex == 2 ? Colors.blue : Colors.black)),
            tileColor: sideMenuIndex == 2 ? color : null,
            onTap: () {
              setState(() {
                sideMenuIndex = 2;
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context)
                  .pushNamed("/LuasDashboard", arguments: "Luas");
            },
          ),
          ListTile(
            title: Text('Events',
                style: TextStyle(
                    color: sideMenuIndex == 3 ? Colors.blue : Colors.black)),
            tileColor: sideMenuIndex == 3 ? color : null,
            onTap: () {
              setState(() {
                sideMenuIndex = 3;
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context)
                  .pushNamed("/EventsDashboard", arguments: "Events");
            },
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
            },
          ),
        ],
      ),
    );
  }
}
