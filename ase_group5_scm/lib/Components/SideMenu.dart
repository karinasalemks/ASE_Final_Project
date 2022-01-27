import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  String? auth = FirebaseAuth.instance.currentUser == null
      ? "guest"
      : FirebaseAuth.instance.currentUser?.email;

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
              )
                  ),
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
