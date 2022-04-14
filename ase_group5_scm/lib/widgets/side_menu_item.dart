import 'package:flutter/material.dart';
import 'package:ase_group5_scm/helpers/reponsiveness.dart';
import 'package:ase_group5_scm/widgets/horizontal_menu_item.dart';
import 'package:ase_group5_scm/widgets/vertical_menu_item.dart';

class SideMenuItem extends StatelessWidget {
  final String itemName;
  final void Function()? onTap;

  const SideMenuItem({Key? key, required this.itemName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomSize(context)) {
      return VertticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    }
  }
}
