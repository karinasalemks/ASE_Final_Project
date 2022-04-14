import 'package:flutter/cupertino.dart';
import 'package:ase_group5_scm/constants/controllers.dart';
import 'package:ase_group5_scm/routing/router.dart';
import 'package:ase_group5_scm/routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: "/overview",
    );
