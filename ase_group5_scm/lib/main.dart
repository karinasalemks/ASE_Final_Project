import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/controllers/menu_controller.dart';
import 'package:ase_group5_scm/controllers/navigation_controller.dart';
import 'package:ase_group5_scm/layout.dart';
import 'package:ase_group5_scm/pages/404/error.dart';
import 'package:ase_group5_scm/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'routing/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(MenuController());
  Get.put(NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: authenticationPageRoute,
      unknownRoute: GetPage(name: '/not-found', page: () => PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(name: rootRoute, page: () {
          return SiteLayout();
        }),
        GetPage(name: authenticationPageRoute, page: () => AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.black
        ),
            pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      }
    ),
        primarySwatch: Colors.blue,
      ),
      // home: AuthenticationPage(),
    );
  }
}
