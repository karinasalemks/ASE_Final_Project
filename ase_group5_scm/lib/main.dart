import 'dart:async';

import 'package:ase_group5_scm/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//remove crashlytics on web
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/controllers/menu_controller.dart';
import 'package:ase_group5_scm/controllers/navigation_controller.dart';
import 'package:ase_group5_scm/layout.dart';
import 'package:ase_group5_scm/pages/404/error.dart';
import 'package:ase_group5_scm/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry/sentry.dart';
import 'package:logging/logging.dart';
import 'package:sentry_logging/sentry_logging.dart';
import 'routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(MenuController());
  Get.put(NavigationController());

  // comment crashlytics on web as it is not supported
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  //test code keep it commented or remove it
  // runZonedGuarded(() {
  //   runApp(MyApp());
  // },FirebaseCrashlytics.instance.recordError);

  await Sentry.init(
        (options) {
      options.dsn = 'https://3c0a6493e803460bafb8ffafea16fd75@o1181777.ingest.sentry.io/6295430';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.addIntegration(LoggingIntegration());
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final log = Logger('main.dart');
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    log.info('started the main app!');
    // try {
    //   throw Exception();
    // } catch (error, stackTrace) {
    //   log.severe('an error!', error, stackTrace);
    // }
    log.info('building main material app!');
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
