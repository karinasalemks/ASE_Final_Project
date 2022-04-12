import 'dart:math';

import 'package:ase_group5_scm/Components/AppConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ase_group5_scm/constants/style.dart';
import 'package:ase_group5_scm/pages/overview/widgets/bar_chart.dart';
import 'package:ase_group5_scm/pages/overview/widgets/revenue_info.dart';
import 'package:ase_group5_scm/widgets/custom_text.dart';

class RevenueSectionLarge extends StatelessWidget {
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 6),
                        color: lightGrey.withOpacity(.1),
                        blurRadius: 12)
                  ],
                  border: Border.all(color: lightGrey, width: .5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomText(
                            text: "Revenue Chart",
                            size: 20,
                            weight: FontWeight.bold,
                            color: lightGrey,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: 500,
                            height: 200,
                            child: LineChart(
                                LineChartData(
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                  // The red line
                                  LineChartBarData(
                                  spots: dummyData1,
                                  isCurved: true,
                                  barWidth: 3,
                                  colors: [
                                    Colors.red,
                                  ],
                                ),
                              ],
                                ),
                          ),
                              // width: 600,
                              // height: 200,
                              // child: SimpleBarChart.withSampleData()
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 120,
                      color: lightGrey,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              RevenueInfo(
                                title: "Toda\'s revenue",
                                amount: "230",
                              ),
                              RevenueInfo(
                                title: "Last 7 days",
                                amount: "1,100",
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              RevenueInfo(
                                title: "Last 30 days",
                                amount: "3,230",
                              ),
                              RevenueInfo(
                                title: "Last 12 months",
                                amount: "11,300",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
  }
}