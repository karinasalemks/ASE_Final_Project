import 'package:flutter/material.dart';
import 'package:test_app/widgets/menu/horizontal_menu_item.dart';
import 'package:test_app/widgets/menu/vertical_menu_item.dart';
import 'package:test_app/widgets/screens/responsive_screen.dart';


class SideMenuItem extends StatelessWidget {
  final String itemName;
  final VoidCallback onTap;

  const SideMenuItem({ Key ?key,required this.itemName,required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(ResponsiveWidget.isLargeScreen(context)){
      return VerticalMenuItem(itemName: itemName, onTap: onTap,);
    }else{
      return HorizontalMenuItem(itemName: itemName, onTap: onTap,);
    }
  }
}