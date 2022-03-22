import 'package:flutter/cupertino.dart';

class Utils{
  static String getAppBarTitle(context){
    String? selectedSideMenu =
    ModalRoute.of(context)?.settings.arguments as String?;
    selectedSideMenu = selectedSideMenu == null || selectedSideMenu.isEmpty?"Dublin Bikes":selectedSideMenu;
    return selectedSideMenu;
  }
}