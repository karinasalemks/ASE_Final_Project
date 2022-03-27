import 'package:flutter/material.dart';
import 'package:ase_group5_scm/helpers/local_navigator.dart';
import 'package:ase_group5_scm/helpers/reponsiveness.dart';
import 'package:ase_group5_scm/widgets/large_screen.dart';
import 'package:ase_group5_scm/widgets/side_menu.dart';

import 'widgets/top_nav.dart';


class SiteLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar:  topNavigationBar(context, scaffoldKey),
      drawer: Drawer(
        child: SideMenu(),
      ),
      body: ResponsiveWidget(
        key: scaffoldKey,
        largeScreen: LargeScreen(),
      smallScreen: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: localNavigator(),
      )
      ),
    );
  }
}
