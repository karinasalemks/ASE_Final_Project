import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/controllers/menu_controller.dart';
import 'package:test_app/layout.dart';

void main(){
  Get.put(MenuController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shubham Codes",
      theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: Colors.black
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            }
        ),
        primarySwatch: Colors.blue,
      ),
      home: SiteLayout(),
    );
  }
}
