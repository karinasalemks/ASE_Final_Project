import 'dart:math';

import 'package:flutter/material.dart';
import 'info_card_small.dart';

Random random = new Random();
int min = 11500;
int avg  = 65;
int luas  = 336;
int randomNumber = min + random.nextInt(100);
int bikeRand = avg + random.nextInt(10);
class OverviewCardsSmallScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   double _width = MediaQuery.of(context).size.width;

    return  Container(
      height: 400,
      child: Column(
        children: [
          InfoCardSmall(
          title: "Buses Co2 estimation :\n",
          value:randomNumber.toString() + " units",
                        onTap: () {},
                        isActive: true,
            // topColor: Colors.orange,
                      ),
                      SizedBox(
                        height: _width / 64,
                      ),
                      InfoCardSmall(
                        title: "Luas Electricity consumption combined :  ",
                        value: luas.toString() + " units",
                        isActive: true,
                        onTap: () {},
                      ),
                     SizedBox(
                        height: _width / 64,
                      ),
                          InfoCardSmall(
                            title: " Dublin Bikes Avg availability percentage :",
                            value: bikeRand.toString() + "%",
                            isActive: true,
                        onTap: () {},
                      ),
                      // SizedBox(
                      //   height: _width / 64,
                      // ),
                      // InfoCardSmall(
                      //   title: "Scheduled deliveries",
                      //   value: "32",
                      //   onTap: () {},
                      // ),
                  
        ],
      ),
    );
  }
}