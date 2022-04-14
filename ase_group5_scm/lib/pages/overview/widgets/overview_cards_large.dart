import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ase_group5_scm/pages/overview/widgets/info_card.dart';

Random random = new Random();
int min = 11500;
int avg = 65;
int luas = 336;
int randomNumber = min + random.nextInt(100);
int bikeRand = avg + random.nextInt(10);

class OverviewCardsLargeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        InfoCard(
          title: "Buses Co2 estimation   ",
          value: randomNumber.toString() + " units",
          onTap: () {},
          topColor: Colors.orange,
        ),
        SizedBox(
          width: _width / 64,
        ),
        InfoCard(
          title: "Luas - green and red Line Electricity consumption ",
          value: luas.toString() + " units",
          topColor: Colors.teal,
          onTap: () {},
        ),
        SizedBox(
          width: _width / 64,
        ),
        InfoCard(
          title: " Dublin Bikes Avg availability percentage :",
          value: bikeRand.toString() + "%",
          topColor: Colors.redAccent,
          onTap: () {},
        ),
      ],
    );
  }
}
