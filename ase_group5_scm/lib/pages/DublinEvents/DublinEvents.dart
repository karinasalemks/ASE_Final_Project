import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/controllers.dart';
import 'package:ase_group5_scm/helpers/reponsiveness.dart';
import 'package:ase_group5_scm/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'events_dashboard_web.dart';

class DublinEvents extends StatelessWidget {
  const DublinEvents({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Obx(() => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top:
                  ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(text: menuController.activeItem.value, size: 24, weight: FontWeight.bold,)),
            ],
          ),),

          Expanded(child: EventsDashboardWeb()),

        ],
      ),
    );
  }
}